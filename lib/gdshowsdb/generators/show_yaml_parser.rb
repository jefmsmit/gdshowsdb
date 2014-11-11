module Gdshowsdb
  class ShowYAMLParser
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