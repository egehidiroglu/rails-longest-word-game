require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @letters = []
    i = 0
    while i < 10
      @letters.push(alphabet[rand(0..(alphabet.size - 1))])
      i += 1
    end
  end

  def array_to_hash(array)
    hash = {}
    array.each do |letter|
      if hash[letter.downcase].nil?
        hash[letter.downcase] = 1
      else
        hash[letter.downcase] += 1
      end
    end
    hash
  end

  def grid(letter_hash, answer_hash)
    bool = true
    answer_hash.each do |key|
      bool = false if letter_hash[key[0]].nil? || answer_hash[key[0]] > letter_hash[key[0]]
    end
    bool
  end

  def result(grid, english, answer, letters)
    if !grid
      result = "Sorry but #{answer} can't be built out of #{letters}"
      score = 0
    elsif grid && !english
      result = "Sorry but #{answer} does not seem to be a valid English word..."
      score = 0
    elsif grid && english
      result = "Congratulations! #{answer} is a valid English word!"
      score = answer.length
    end
    [result, score]
  end

  def score
    @answer = params[:answer].upcase
    @letters = params[:letters].upcase
    @letters_hash = array_to_hash(@letters.split)
    @answer_hash = array_to_hash(@answer.downcase.chars)
    @grid = grid(@letters_hash, @answer_hash)
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    response_serialized = URI.open(url).read
    @english = JSON.parse(response_serialized)['found']
    @result = result(@grid, @english, @answer, @letters)[0]
    session[:score] += result(@grid, @english, @answer, @letters)[1]
    session[:try] += 1
  end
end
