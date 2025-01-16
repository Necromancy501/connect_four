require_relative 'rainbow_helper'

class Pegs
  include RainbowHelper

  attr_reader :chip
  attr_accessor :address

  def initialize(char)
    @chip = create_chip(char)
    @address = nil
  end

  def create_chip(char)
    case char
    when 'r'
      colorize("◉", :red)
    when 'b'
      colorize("◉", :blue)
    when 'y'
      colorize("◉", :yellow)
    when 'g'
      colorize("◉", :green)
    else
      nil
    end
  end
  
end
