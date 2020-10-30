# frozen_string_literal: false

# node class
class Node
  include Comparable
  # attr_reader :value
  attr_accessor :left_child, :right_child, :value

  def <=>(other)
    value <=> other.value
  end

  def initialize(value = nil)
    @value = value
    @left_child = nil
    @right_child = nil
  end
end