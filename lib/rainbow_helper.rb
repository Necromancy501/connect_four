require 'rainbow/refinement'
using Rainbow

module RainbowHelper
  def colorize(text, color)
    text.send(color)
  end
end