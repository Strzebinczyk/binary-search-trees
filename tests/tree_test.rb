require_relative '../tree'
require 'test/unit'

class TreeTest < Test::Unit::TestCase
  def test_initialize
    tree = Tree.new([1, 2, 3])
    expected = 2
    assert_equal(expected, tree.root.data)
    tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
    expected = 8
    assert_equal(expected, tree.root.data)
  end
end
