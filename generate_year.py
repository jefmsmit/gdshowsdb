#!/usr/bin/env python3
"""Generate a year's YAML from JerryBase, preserving existing UUIDs where possible."""

import sqlite3, yaml, uuid, sys
from collections import defaultdict

DB_PATH = "/Users/jeff/dev/GratefulDead/music_album_rename/JerryBase.db"
YAML_DIR = "/Users/jeff/dev/gdshowsdb/data/gdshowsdb"


def yaml_safe_str(s):
    """Quote string if it contains YAML special characters like # or &."""
    if ' #' in s or s.startswith('#') or '&' in s:
        return "'" + s.replace("'", "''") + "'"
    return s


def load_existing(year):
    path = f"{YAML_DIR}/{year}.yaml"
    try:
        with open(path) as f:
            return yaml.safe_load(f) or {}
    except FileNotFoundError:
        return {}


def yaml_key_from_date(date_str, idx):
    y, m, d = date_str.split('-')
    base = f"{y}/{m}/{d}"
    return base if idx is None else f"{base}/{idx}"


def find_existing_uuid(existing, date_str, idx):
    """Try to find an existing show UUID for this date/index."""
    y, m, d = date_str.split('-')
    base = f"{y}/{m}/{d}"
    if idx is None:
        candidates = [base]
    elif idx == 0:
        # First indexed show may inherit a previously unindexed show's UUID
        candidates = [f"{base}/0", base]
    else:
        # Subsequent indexed shows must match their exact key; never steal the base UUID
        candidates = [f"{base}/{idx}"]
    for k in candidates:
        if k in existing:
            return existing[k][':uuid']
    return str(uuid.uuid4())


def generate_year(year):
    existing = load_existing(year)

    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()

    cur.execute("""
        SELECT e.id, e.event_key, e.event_date, e.early_late,
               v.name as venue, v.city, v.state, v.country
        FROM events e JOIN venues v ON e.venue_id=v.id
        WHERE e.act_id IN (1,3) AND e.canceled=0 AND e.placeholder=0
          AND e.public=1 AND e.year=?
        ORDER BY e.event_key
    """, (year,))
    shows = cur.fetchall()

    # Group by date to detect multi-show days without early/late
    date_groups = defaultdict(list)
    for s in shows:
        m, d, y_str = s['event_date'].split('/')
        date_str = f"{y_str}-{int(m):02d}-{int(d):02d}"
        date_groups[date_str].append(s)

    lines = ["---\n"]

    for date_str, day_shows in sorted(date_groups.items()):
        no_el = [s for s in day_shows if not s['early_late']]
        has_el = [s for s in day_shows if s['early_late']]

        indexed = []
        for s in has_el:
            idx = 0 if s['early_late'] == 'EARLY' else 1
            indexed.append((idx, s))
        if len(no_el) == 1:
            indexed.append((None, no_el[0]))
        else:
            for i, s in enumerate(no_el):
                indexed.append((i, s))

        indexed.sort(key=lambda x: (x[0] is not None, x[0] if x[0] is not None else -1))

        for idx, show in indexed:
            key = yaml_key_from_date(date_str, idx)
            show_uuid = find_existing_uuid(existing, date_str, idx)

            # Get sets with their songs
            cur2 = conn.cursor()
            cur2.execute("""
                SELECT es.id, es.seq_no
                FROM event_sets es
                WHERE es.event_id=?
                ORDER BY es.seq_no
            """, (show['id'],))
            sets = cur2.fetchall()

            lines.append(f"{key}:\n")
            lines.append(f"  :uuid: {show_uuid}\n")
            lines.append(f"  :venue: {show['venue']}\n")
            lines.append(f"  :city: {show['city'] or ''}\n")
            lines.append(f"  :state: {show['state'] or ''}\n")
            lines.append(f"  :country: {show['country'] or ''}\n")

            # Collect all songs across all sets
            all_songs = []
            for s in sets:
                cur3 = conn.cursor()
                cur3.execute("""
                    SELECT s.name, esong.segue
                    FROM event_songs esong
                    JOIN songs s ON s.id=esong.song_id
                    WHERE esong.event_set_id=?
                    ORDER BY esong.seq_no
                """, (s['id'],))
                all_songs.append(cur3.fetchall())

            if not any(all_songs):
                lines.append(f"  :sets: []\n")
            else:
                lines.append(f"  :sets:\n")
                for set_songs in all_songs:
                    if not set_songs:
                        continue
                    lines.append(f"  - :uuid: {uuid.uuid4()}\n")
                    lines.append(f"    :songs:\n")
                    for song_name, segue in set_songs:
                        seg_str = 'true' if segue else 'false'
                        lines.append(f"    - :uuid: {uuid.uuid4()}\n")
                        lines.append(f"      :name: {yaml_safe_str(song_name)}\n")
                        lines.append(f"      :segued: {seg_str}\n")

    path = f"{YAML_DIR}/{year}.yaml"
    with open(path, 'w') as f:
        f.writelines(lines)

    conn.close()
    return len(date_groups)


if __name__ == '__main__':
    years = [int(a) for a in sys.argv[1:]] if len(sys.argv) > 1 else range(1965, 1996)
    for year in years:
        count = generate_year(year)
        print(f"{year}: wrote {count} shows")
