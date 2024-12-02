require_relative 'node'
class Tree
  attr_reader :root

  def initialize(array = [1, 2, 8, 3, 3, 7, 3, 4, 5, 6, 7])
    @data = prepare_array(array)
    @root = build_tree(@data)
  end

  def build_tree(array)
    return nil if array.empty?
    return Node.new(array.first) if array.length == 1

    middle = array.length / 2
    root = Node.new(array[middle])
    root.left = build_tree(array.take(middle))
    root.right = build_tree(array.drop(middle + 1))
    root
  end

  def prepare_array(array)
    array.uniq.sort
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, root = @root)
    return nil if value == root.data

    if value < root.data
      if root.left.nil?
        root.left = Node.new(value)
      else
        insert(value, root.left)
      end
    elsif root.right.nil?
      root.right = Node.new(value)
    else
      insert(value, root.right)
    end
  end

  def find(value, node = @root)
    return node if value == node.data

    if value < root.data
      return nil if root.left.nil?

      find(value, root.left)

    else
      return nil if root.right.nil?

      find(value, root.right)

    end
  end

  def delete(value, root = @root)
    return root if root.nil?

    current = root
    if value > current.data
      current.right = delete(value, current.right)
    elsif value < current.data
      current.left = delete(value, current.right)
    else
      if current.left.nil?
        temporary = current.right
        current = nil
        return temporary
      elsif current.right.nil?
        temporary = current.left
        current = nil
        return temporary
      end

      temp = next_min(current.right)
      current.data = temp.data
      current.right = delete(temp.data, current.right)
    end
    current
  end

  def next_min(node)
    node = node.left until node.left.nil?
    node
  end

  def level_order(node = @root)
    return if node.nil?

    output = []
    queue = []
    queue.push(node)
    until queue.empty?
      current = queue.shift
      if block_given?
        output.push(yield(current))
      else
        output.push(current.data)
      end
      queue.push(current.left) if current.left
      queue.push(current.right) if current.right
    end

    output
  end

  def inorder(node = @root, output = [], &block)
    return if node.nil?

    inorder(node.left, output, &block)
    if block_given?
      output.push(block.call(node))
    else
      output.push(node.data)
    end
    inorder(node.right, output, &block)

    output
  end

  def preorder(node = @root, output = [], &block)
    return if node.nil?

    if block_given?
      output.push(block.call(node))
    else
      output.push(node.data)
    end
    inorder(node.left, output, &block)
    inorder(node.right, output, &block)

    output
  end

  def postorder(node = @root, output = [], &block)
    return if node.nil?

    inorder(node.left, output, &block)
    inorder(node.right, output, &block)
    if block_given?
      output.push(block.call(node))
    else
      output.push(node.data)
    end

    output
  end

  def height(node = @root, count = -1)
    return count if node.nil?

    count += 1
    [height(node.left, count), height(node.right, count)].max
  end

  def depth(node)
    return nil if node.nil?

    current = @root
    count = 0
    until current.data == node.data
      count += 1
      current = current.left if node.data < current.data
      current = current.right if node.data > current.data
    end

    count
  end

  def balanced?(node = root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)

    false
  end

  def rebalance!
    values = inorder
    @root = build_tree(values)
  end
end

arr = (Array.new(15) { rand(1..100) })
tree = Tree.new(arr)
p tree.balanced?
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
p tree.pretty_print
10.times do
  a = rand(100..150)
  tree.insert(a)
  puts "Inserted #{a} to tree."
end
p tree.balanced?
p tree.pretty_print
puts '--------------------------------------'
tree.rebalance!
p tree.pretty_print
p tree.balanced?
