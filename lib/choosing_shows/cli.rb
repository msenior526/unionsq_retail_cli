require 'pry'
require "tty-prompt"

class CLI

    attr_accessor :input, :stores, :choices, :selection
    
    def start
        greeting
        select_store_msg
        choose_store
        display_store_info
    end

    def picture
        puts "
                                                                888      
                                                                888      
                                                                888      
            88888b.  .d88b. 888  888  888888  888 .d88b. 888d888888  888 
            888 `88bd8P  Y8b888  888  888888  888d88``88b888P`  888 .88P 
            888  88888888888888  888  888888  888888  888888    888888K  
            888  888Y8b.    Y88b 888 d88PY88b 888Y88..88P888    888 `88b 
            888  888 `Y8888  `Y8888888P`  `Y88888 `Y88P` 888    888  888 
                                            8888                        
                                        Y8b d88P                        
                                         `Y88P`         ".green     
    end

    def greeting
        puts ""
        picture
        puts ""
        puts "Welcome, to the Union Square Retail Guide. Here you can view all of the retail businesses in only the Union Square area.".white
        puts ""
        puts "Here's a list of the business types you can choose from:".white
        puts ""
        API.get_businesses
        display_business_types  
    end
    

    def display_business_types
        BusinessType.all.each_with_index do |types, index|
            puts "#{index + 1}: #{types.type.green}"
        end
        puts ""
        puts "Enter a number between 1-#{BusinessType.all.length} to choose which business type you would like to see more of.".white
        user_input
    end

    def user_input
        @input = gets.strip.to_i
        if !input.between?(1, BusinessType.all.length)
            puts "INVALID INPUT. Please enter a number between 1-#{BusinessType.all.length}.".red
            user_input
        else
          find_businesses
        end
    end

    def find_businesses
        type = BusinessType.all[input - 1].type
        @stores = RetailStore.all.select do |store|
            store.business_type.type == type
        end
    end

    def choose_store
       @choices = stores.collect do |type|
           type.business
       end
        prompt = TTY::Prompt.new
        @selection = prompt.enum_select("Select a store.", choices, per_page: 10)
        display_store_info
    end

    def select_store_msg
        puts "To get more information about a store, choose a number between 1-#{stores.length}.".white
    end

    def display_store_info
        prompt = TTY::Prompt.new
        store = stores.find {|store| store.business == selection}
        puts ""
        puts "#{store.business}".blue
        puts "Phone Number: #{store.phone_number}"
        puts "Address: #{store.parsed_address}"
        puts "         #{store.city_state}"
        puts "         #{store.zip_code}"
        puts ""
        prompt.yes?("Would you like to choose a different store?".white)? repeat : goodbye
    end

    def repeat 
        display_business_types
        select_store_msg
        choose_store
        display_store_info
    end

    def goodbye
        puts ""
        puts "Thanks for using the Union Square Retail Guide CLI!".yellow
        exit
    end
end