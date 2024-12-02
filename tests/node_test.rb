require_relative '../node'
require 'test/unit'

class NodeTest < Test::Unit::TestCase
  def test_initialize
    node = Node.new(3)
    expected = 3
    assert_equal(expected, node.data)
  end

  def test_compare
    node1 = Node.new(3)
    node2 = Node.new(17)
    expected = -1
    assert_equal(expected, node1.<=>(node2))
  end
end
