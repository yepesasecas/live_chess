defmodule LiveChess.Dictionary do
  def random_word do
    Dictionary.random_word()
  end

  def two_random_words do
    "#{Dictionary.random_word()}_#{Dictionary.random_word()}"
  end
end
