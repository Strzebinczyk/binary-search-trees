class Node
  attr_accessor :data, :left, :right

  include Comparable

  def initialize(data = nil)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    @data <=> other.data
  end
end
