# frozen_string_literal: false

require 'pry'

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

# tree class
class Tree
  attr_accessor :root

  def initialize(array)
    tree_array = array.uniq.sort
    @root = build_tree(tree_array)
  end

  def build_tree(tree_array, first_index = 0, last_index = tree_array.length - 1)
    return nil if first_index > last_index

    mid = (first_index + last_index) / 2
    root = Node.new(tree_array[mid])
    root.left_child = build_tree(tree_array, first_index, mid - 1) # first_index not 0 !!!
    root.right_child = build_tree(tree_array, mid + 1, last_index)

    root
  end

  def insert(value, node = root)
    # return self.root = Node.new(value) if root.nil? 
    # would only matter if tree is empty and can't have a tree from an empty array anyway

    return Node.new(value) if node.nil?

    return node if node.value == value

    if value < node.value
      node.left_child = insert(value, node.left_child)
    else
      node.right_child = insert(value, node.right_child)
    end

    node # imperative

###### recursive return lesson
    # 2, 8 node
    #   2 < 8
    #     8.left_child = insert(2, 4)
    #       2 < 4
    #         4.left_child = insert(2,1)
    #           2 > 1
    #             1.right_child = insert(2, 3)
    #               2 < 3
    #                 3.left_child = insert(2, nil) # left
    #                   return Node.new(2)
    # when no final 'return node', Node.new(2) passed all the way back up as return value
                    # 3.left_child = Node.new(2)
                  #  1.right_child = Node.new(2)
                # 4.left_child = Node.new(2)
              # 8.left_child = Node.new(2)
    # when final 'return node', 
                    # 3.left_child = 2
                  #  1.right_child = 3
                # 4.left_child = 1
              # 8.left_child = 4

  end

  def find(value, node = root)
    return 'Value does not exist in the binary tree yet' if node.nil?
    return node if value == node.value

    if value < node.value
      find(value, node.left_child)
    else
      find(value, node.right_child)
    end
    # node
  end
# 
  def delete(value, node = root)
    return node if node.nil?

    case
    when value < node.value
      node.left_child = delete(value, node.left_child) # changing the pointer
    when value > node.value
      node.right_child = delete(value, node.right_child)
    when value == node.value
      return node.right_child if node.left_child.nil?
      return node.left_child if node.right_child.nil?

      parent = node
      child = node.right_child
      until child.left_child.nil?
        parent = child
        child = child.left_child
      end

      if parent == node # moves pointer to skip the first-right node since it's taking deleted nodes place
        parent.right_child = child.right_child
      else # if take more than the single move to the right to find a node with left.nil?
        parent.left_child = child.right_child # moves pointer to skip over last left node that's being moved up
      end
      node.value = child.value
    end
    node ####
  end

  def level_order(node = root, queue = [], tree_values = [])
    return if node.nil?

    queue << node.left_child unless node.left_child.nil?
    queue << node.right_child unless node.right_child.nil?
    tree_values << node.value

    tree_values << level_order(queue[0], queue[1..-1]) if queue.size.positive?
    return tree_values.flatten
  end

  # depth first traversal
  def in_order(node = root, tree_values = [])
    return if node.nil?

    tree_values << in_order(node.left_child) unless node.left_child.nil?
    tree_values << node.value
    tree_values << in_order(node.right_child) unless node.right_child.nil?
    tree_values.flatten
  end

  # depth first traversal
  def pre_order(node = root, tree_values = [])
    return if node.nil?

    tree_values << node.value
    tree_values << pre_order(node.left_child) unless node.left_child.nil?
    tree_values << pre_order(node.right_child) unless node.right_child.nil?
    tree_values.flatten
  end

  # depth first traversal
  def post_order(node = root, tree_values = [])
    return if node.nil?

    tree_values << post_order(node.left_child) unless node.left_child.nil?
    tree_values << post_order(node.right_child) unless node.right_child.nil?
    tree_values << node.value
    tree_values.flatten
  end

  def height(value, node = root)
    return "#{value} does not exist in the binary tree" if node.nil?
    return height(value, node.left_child) if value < node.value
    return height(value, node.right_child) if value > node.value
    # return 0 if node.right_child.nil? && node.left_child.nil?
    count_to_leaf(node)
  end

  def count_to_leaf(node = root)
    return -1 if node.nil?

    left_count = 1 + count_to_leaf(node.left_child)
    right_count = 1 + count_to_leaf(node.right_child)

    left_count < right_count ? right_count : left_count # return the higher count
  end

  def depth(value, node = root, depth = 0)
    # return nil if node.nil?
    raise "#{value} does not exist in the binary  tree" if node.nil?
    return 0 if value == node.value

    # return "#{value} does not exist in the tree" if node.left_child.nil? && node.right_child.nil?

    if value < node.value
      1 + depth(value, node.left_child)
    else
      1 + depth(value, node.right_child)
    end
  end

  def balanced?(node = root)
    (count_to_leaf(node.left_child) - count_to_leaf(node.right_child)).abs < 2
    # binding.pry
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

  # pretty print method borrowed from The Odin Project
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

example = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324, 6, 2]
test_tree = Tree.new(example)
test_tree.pretty_print
test_tree.delete(4)
test_tree.delete(6)
test_tree.pretty_print
p test_tree.balanced?
test_tree.delete(5)
test_tree.delete(1)
test_tree.pretty_print
p test_tree.balanced?
test_tree.delete(2)
test_tree.pretty_print
p test_tree.balanced?
test_tree.delete(3)
test_tree.pretty_print
# p test_tree.level_order
# p test_tree.depth(67)
# p test_tree.depth(7)
# p test_tree.depth(8)
# p test_tree.depth(42)
p test_tree.balanced?

# p test_tree.height(7)
# p test_tree.height(23)
# p test_tree.height(1)
# p test_tree.height(4)
# p test_tree.height(9)
# p test_tree.height(47)

# p test_tree.in_order
# p 'pre:'
# p test_tree.pre_order
# p 'post:'
# p test_tree.post_order

# puts test_tree.find(9)
# puts test_tree.find(42)
# test_tree.delete(1)
# test_tree.pretty_print
