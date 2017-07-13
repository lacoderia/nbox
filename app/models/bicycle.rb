class Bicycle
  include ActiveModel::Model

  attr_accessor :position, :number

  #USED in seeds.rb
  def self.to_string_array bicycle_array

    result = "["
    bicycle_array.each do |bicycle|
      result += "{position:#{bicycle.position}, number:#{bicycle.number}},"
    end
    result.chop!
    result += "]"
    return result
  end

  def self.to_bicycle_array bicycle_text
    bicycle_array = []
    
    eval(bicycle_text).each do |bicycle|
      bicycle_array << Bicycle.new(bicycle)
    end
    return bicycle_array
  end
  
end
