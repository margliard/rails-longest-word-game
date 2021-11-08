require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(9)
    @answer = params[:word]
  end

  def score
    # raise
    @letters = params[:letters].split
    @word = (params[:word] || '').upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    if @included
      if @english_word
        "Congratulations! #{@word} is a valid English word!"
      else
        "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      "Sorry but #{@word} can't be built out of #{@letters.join(", ")}"
    end
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}", 'r')
    json = JSON.parse(response.read)
    json['found']
  end
end
