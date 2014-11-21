module Gdshowsdb
  class ShowYAMLParser
    def self.from_yaml(year)
      ShowYAMLParser.new(Gdshowsdb.load_yaml_for_year(year))
    end

    def initialize(shows)
      @shows = shows
    end

    def parse
      parsed = []
      @shows.each do |key, value|
        date_info = Show.parse_date(key)
        parsed.push(date_info.merge({uuid: value[:uuid], venue: value[:venue], city: value[:city], state: value[:state], country: value[:country]}))
      end
      parsed
    end
  end
end