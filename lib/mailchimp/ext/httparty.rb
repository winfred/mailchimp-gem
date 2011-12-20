module HTTParty
  module HashConversions
    # @param key<Object> The key for the param.
    # @param value<Object> The value for the param.
    #
    # @return <String> This key value pair as a param
    #
    # @example normalize_param(:name, "Bob Jones") #=> "name=Bob%20Jones&"
    def self.normalize_param(key, value)
      param = ''
      stack = []

      if value.is_a?(Array)
        param << Hash[*(0...value.length).to_a.zip(value).flatten].map {|i,element| normalize_param("#{key}[#{i}]", element)}.join
      elsif value.is_a?(Hash)
        stack << [key,value]
      else
        param << "#{key}=#{URI.encode(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}&"
      end

      stack.each do |parent, hash|
        hash.each do |key, value|
          if value.is_a?(Hash)
            stack << ["#{parent}[#{key}]", value]
          else
            param << normalize_param("#{parent}[#{key}]", value)
          end
        end
      end

      param
    end
  end
end