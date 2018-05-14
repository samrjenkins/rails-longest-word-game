require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times do
      @letters << ("A".."Z").to_a.sample
    end
  end

  def score
    @word = params[:word]
    @score = 0
    session[:score] ||= 0

    if !word_from_grid?(params[:word], params[:letters].split(" "))
      @response = "Word not in grid"
    elsif !dict_response(params[:word])["found"]
      @response = "Word not in grid"
    else
      @response = "#{params[:word].capitalize} is a valid guess!"
      @score = params[:word].length
      session[:score] += @score
    end
    @current_session_score = session[:score]
  end

  private

  def word_from_grid?(attempt, letters)
    attempt.split("").each do |letter|
      letters.include?(letter.upcase) ? letters.delete_at(letters.index(letter.upcase)) : (return false)
    end
    true
  end

  def dict_response(word)
    JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{word}").read)
  end
end
