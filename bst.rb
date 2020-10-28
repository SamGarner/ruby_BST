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

  def initialize(value)
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

  def delete(value, node = root)
    return node if node.nil?

    case
      #binding.pry
    when value == node.value
      if node.right_child.nil? && node.left_child.nil?
        node.value = nil # how to ~remove~ rather than just setting to nil ?
        return "leaf #{value} deleted"
      elsif node.left_child.nil?
        node.value = node.right_child
        node.left_child = (node.left_child).left_child
        node.right_child = (node.right_child).right_child
      elsif node.right_child.nil?
        # reverse of left_child.nil? above
      else # has two children
        #
      end
    when value < node.value
      delete(value, node.left_child)
    when value > node.value
      delete(value, node.right_child)
    end
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

example = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
test_tree = Tree.new(example)
test_tree.pretty_print
test_tree.delete(7)
test_tree.pretty_print
