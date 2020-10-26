# frozen_string_literal: false

# node class
class Node
  include Comparable
  # attr_reader :value
  attr_accessor :left_child, :right_child, :value

  def <=>(other)
    value <=> other.value
  end

  def initialize(value)
    @value = value
    @left_child = nil
    @right_child = nil
  end
end

# tree class
class Tree
  attr_reader :root

  def initialize(array)
    tree_array = array.uniq.sort
    @root = build_tree(tree_array)
  end

  def build_tree(tree_array, first_index = 0, last_index = tree_array.length - 1)
    return nil if first_index > last_index

    mid = (first_index + last_index) / 2
    root = Node.new(tree_array[mid])
    root.left_child = build_tree(tree_array, first_index, mid - 1) # WHY WORKS WHEN first_index but not 0 ???
    root.right_child = build_tree(tree_array, mid + 1, last_index)

    root
  end

# build_tree([1, 2, 3], 0, 2)
#   mid = 1
#   root = tree_array[1] = 2             ####
#   root.left_child
#     build_tree([1, 2, 3], 0, 0)
#     mid = 0
#     root = tree_array[0] = 1           #####
#       root.left_child
#         build_tree([1, 2, 3], 0, -1)
#         nil
#       root.right_child
#         build_tree([1, 2, 3], 1, 0)
#         nil
#   root.right_child
#     build_tree([1, 2, 3], 2, 2)
#     mid = 2
#     root = tree_array[2] = 3          #####
#       root.left_child
#         build_tree([1, 2, 3], 2, 1)
#         nil
#       root.right_child
#         build_tree([1, 2, 3], 3, 2)
#         nil

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

p test_tree = Tree.new([3, 1, 2])
test_tree.pretty_print
