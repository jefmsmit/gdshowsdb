require 'yaml'

module Gdshowsdb

  class ShowDiff

    def initialize(year)
      @year = year
    end

    def diff    
      show_data = yaml_shows
      show_data_db = database_shows
      
      find_shows_changed(show_data, show_data_db)        
    end

    private

    def find_shows_changed(show_data, show_data_db)
      @deleted_shows = nil
      @new_shows = nil
      @updated_shows = nil

      show_keys = show_data.keys.sort
      show_keys_db = show_data_db.keys.sort

      update_shows(show_data, show_data_db)
      remove_shows(show_keys, show_keys_db, show_data_db)
      add_new_shows(show_keys, show_keys_db, show_data)

      if(@deleted_shows)
        puts "Deleted Shows for #{@year}"
        @deleted_shows.each do |show|
          puts show.date_identifier
        end
      end

      if(@new_shows)
        puts "New Shows for #{@year}"
        @new_shows.each do |show|
          puts show.date_identifier
        end
      end

      if(@updated_shows)
        puts "Updated shows for #{@year}"
        @updated_shows.each do |show|
          puts show.date_identifier
        end
      end
    end 

    def update_shows(show_data, show_data_db)
      show_data.each do |key, val|

        show = show_data_db[key]
        db_map = extract_show_basics(show.attributes) if show_data_db[key]
        yaml_map = extract_show_basics(val)        
        
        update_show(val, show) unless db_map == yaml_map || show == nil       
      end
    end

    def update_show(new_show_data, show)
      show.city = new_show_data[:city]
      show.state = new_show_data[:state]
      show.country = new_show_data[:country]
      show.venue = new_show_data[:venue]
      @updated_shows = [] unless @updated_shows
      @updated_shows.push(show)
    end

    def extract_show_basics(show_hash)
      show_hash.select do |key, value| 
        extracted_hash = [:city, :state, :country, :venue].include?(key.to_sym)              
      end.inject({}) do |symboled, (k,v)| 
        symboled[k.to_sym] = v
        symboled
      end
    end

    def remove_shows(show_keys, show_keys_db, show_data_db)    
      removed_shows = show_keys_db - show_keys    

      removed_shows.each do |show_date|
        remove_show(show_data_db[show_date])
      end
    end

    def add_new_shows(show_keys, show_keys_db, show_data)    
      new_shows = show_keys - show_keys_db

      new_shows.each do |show_date|
        add_show(show_date, show_data[show_date])
      end
    end

    def remove_show(show)
      @deleted_shows = [] unless @deleted_shows
      @deleted_shows.push(show)
    end

    def add_show(show_date, show)
      @new_shows = [] unless @new_shows
      new_show = Show.new(show.merge(Show.parse_date(show_date)))

      @new_shows.push(new_show)    
    end   

    def yaml_shows
      YAML.load_file(Gem.datadir('gdshowsdb') + "/#{@year}.yaml")
    end

    def database_shows
      show_data_db = {}
      Show.find_all_by_year(@year.to_i).each do |show|
        show_data_db[show.date_identifier] = show
      end 
      show_data_db
    end

  end

end
