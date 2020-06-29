class Map

    attr_reader :aMap

    def initialize
        @aMap = []
    end

    def set(key, value)
        @aMap << [key, value] if ! aMap.any? {|pair| pair[0] == key}
    end

    def get(key)
        aMap.each {|pair| return pair[1] if pair[0] == key}
        nil
    end

    def delete(key)
        aMap.each_with_index {|pair, i| @aMap.delete_at(i) if pair[0] == key}
    end

    def show()
        puts "["
        aMap.each {|pair| puts "#{pair[0]} => #{pair[1]}"}
        puts "]"
    end
end

m1 = Map.new
