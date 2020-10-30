# frozen_string_literal: false

require 'pry'
require_relative 'lib/node.rb'
require_relative 'lib/tree.rb'

# example = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324, 6, 2]
# test_tree = Tree.new(example)

test_tree = Tree.new(Array.new(15) { rand(1..100) })
test_tree.pretty_print
p test_tree.balanced?
p test_tree.level_order
p test_tree.pre_order
p test_tree.post_order
p test_tree.in_order
test_tree.insert(133)
test_tree.insert(172)
test_tree.insert(1509)
test_tree.insert(2201)
test_tree.pretty_print
p test_tree.balanced?
test_tree.rebalance
test_tree.pretty_print
p test_tree.balanced?
p test_tree.level_order
p test_tree.pre_order
p test_tree.post_order
p test_tree.in_order
