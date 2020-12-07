require 'pry'

class CLI
    BUSINESS_TYPE = ["Apparel and Footwear", "Beauty", "Books and News", "Electronics and Video", "Entertainment, Music and Games", "Gifts and Florists", "Home Furnishings", "Office Supplies and Stationary", "Optical", "Pharmacies"]
    def start
        greeting
    end

    def greeting
        puts "Welcome, to the Union Square retail guide."
        puts "Here is a list of the different types of retail businesses in the area." 
        display_business_types  
    end

    def display_business_types
        BUSINESS_TYPE.each_with_index do |type, index|
            puts "#{index + 1}: #{type}"
        end
    end

end