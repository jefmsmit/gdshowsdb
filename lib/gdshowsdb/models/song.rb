class Song < ActiveRecord::Base
	include Extensions::UUID
  
	belongs_to :show_set, :foreign_key => :show_set_uuid, :primary_key => :uuid
	belongs_to :song_ref, :foreign_key => :song_ref_uuid, :primary_key => :uuid
	
	attr_accessible :uuid, :song_ref_uuid, :show_set_uuid, :show_set, :position, :segued
  
  def self.create_from(spec)
    Song.create(remove_name(spec)) do |song|
      song.show_set = ShowSet.find_by_uuid(spec[:show_set_uuid])
    end
    create_song_relationships(spec)
    Song.find_by_uuid(spec[:uuid])
  end

  def self.create_song_relationships(spec)
    song_ref = SongRef.find_by_name(spec[:name])
    song_ref.songs << Song.find_by_uuid(spec[:uuid])
    
    song_ref.song_occurences.create(uuid: SecureRandom.uuid, position: spec[:position]) do |occurence|
      occurence.show = ShowSet.find_by_uuid(spec[:show_set_uuid]).show         
    end
  end

  def self.update_from(spec)
    read_song = Song.find_by_uuid(spec[:uuid])
    read_song.show_set = ShowSet.find_by_uuid(spec[:show_set_uuid])
    read_song.update(remove_name(spec))
    Song.find_by_uuid(spec[:uuid])
  end

  def self.update_song_relationships(spec)
    remove_song_relationships(spec)
    create_song_relationships(spec)
  end
  
  def self.remove_from(spec)
    remove_song_relationships(spec)
    Song.find_by_uuid(spec[:uuid]).delete    
  end

  def self.remove_song_relationships(spec)
    song_ref = SongRef.find_by_name(spec[:name])
    song_ref.songs.delete(Song.find_by_uuid(spec[:uuid]))
    show_set = ShowSet.find_by_uuid(spec[:show_set_uuid])

    if show_set.nil?
      puts "%%%%%%%%%%%%%%%%%%%%%"
      puts spec.inspect
      puts spec[:show_set_uuid]
    end

    show = ShowSet.find_by_uuid(spec[:show_set_uuid]).show



    song_ref.song_occurences.where('show_uuid = ? and song_ref_uuid = ?', show.uuid, song_ref.uuid).each do | occurence|
      song_ref.song_occurences.delete(occurence)
      occurence.delete
    end
  end

  def self.find_all_by_year(year)
    Song.joins(:show_set => [:show]).where('shows.year = ?', year)
  end

  private 
  def self.remove_name(spec)
    spec.reject {|k,v| k == :name }
  end
end