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

  def score
    @answer = params[:answer]
    @letters = params[:letters]
    @letters_hash = {}
    @answer_hash = {}
    @letters.split.each do |letter|
      if @letters_hash[letter.downcase].nil?
        @letters_hash[letter.downcase] = 1
      else
        @letters_hash[letter.downcase] += 1
      end
    end
    @answer.downcase.chars do |letter|
      if @answer_hash[letter.downcase].nil?
        @answer_hash[letter.downcase] = 1
      else
        @answer_hash[letter.downcase] += 1
      end
    end
    raise
  end
end
