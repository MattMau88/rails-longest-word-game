require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    grid_size = Random.rand(8..10)
    @letters = Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def score
    @grid = params[:letters]
    @word = params[:word]
    @word_check = english_word?(@word)
    if included?(@word.upcase, @grid)
      if @word_check == true
        @output = "Congratulations! '#{@word.upcase}' is a valid English word!"
      else
        @output = "Sorry, but '#{@word.upcase}' is not an English word."
      end
    else
      @output = "Sorry, but '#{@word.upcase}' can't be built out of '#{@grid}'."
    end
    return @output
  end
end
