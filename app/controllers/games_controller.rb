require 'open-uri'

class GamesController < ApplicationController
    def new
        @alphabet_array = ('a'..'z').to_a
        @letters = []
        10.times {@letters << @alphabet_array.sample}
    end

    def score
        @word = params[:word].downcase
        @result = valid_word?(@word)
        @grid = params[:grid]
        @include = check_grid

        if @result && @include 
            @final = "Congratulations! #{@word.upcase} is a valid english word"
        elsif @result == false && @include == true
            @final = "Sorry but #{@word.upcase} does not seem to be valid English word..."
        else
            @final = "Sorry but #{@word.upcase} can't be built out of #{@grid}"
        end
    end
    
    def valid_word?(word)
        url = "https://wagon-dictionary.herokuapp.com/#{word}"
        word = URI.open(url).read
        json_result = JSON.parse(word)
        return json_result["found"]
    end
    
    def check_grid
        @word_split = @word.split("")
        @word_split.all? do |letter|
            @grid.include?(letter) && @word_split.count(letter) <= @grid.count(letter)
        end
    end
end