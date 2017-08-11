class Station 
  include ActiveModel::Model

  attr_accessor :position, :number, :description

  #USED in seeds.rb
  def self.to_string_array station_array

    result = "["
    station_array.each do |station|
      result += "{position:#{station.position}, number:#{station.number}, description:'#{station.description}'}"
    end
    result.chop!
    result += "]"
    return result
  end

  def self.to_station_array station_text
    station_array = []
    
    eval(station_text).each do |station|
      station_array << Station.new(station)
    end
    return station_array
  end
  
end
