module Searchable
  def dfs(target)
    return self if value == target

    children.each do |child|
      next if child.nil?

      result = child.dfs(target)
      return result unless result.nil?
    end

    nil
  end

  def bfs(target)
    nodes = [self]
    until nodes.empty?
      node = nodes.shift

      return node if node.value == target

      node.children.each { |child| nodes << child unless child.nil? }
    end

    nil
  end
end

class BinaryTreeNode
  include Searchable

  attr_accessor :value
  attr_reader :parent

  def initialize(value = nil)
    @value = value
    @parent = nil
    @children = [nil, nil]
  end

  def children
    @children.reject { |child| child.nil? }
  end

  def left_child
    @children[0]
  end

  def right_child
    @children[1]
  end

  def left_child=(child)
    set_child(child, 0)
  end

  def right_child=(child)
    set_child(child, 1)
  end

  protected
  attr_writer :parent

  def set_child(new_child, position)
    unless [0, 1].include?(position)
      raise IllegalArgumentError.new("invalid position")
    end

    old_child = @children[position]

    # don't need to do anything if they're equal
    return if old_child == new_child

    old_child.parent = nil if old_child
    new_child.parent = self if new_child

    @children[position] = new_child
  end
end

class PolyTreeNode
  include Searchable

  attr_accessor :value
  attr_reader :parent

  def initialize(value = nil)
    @value = value

    @parent = parent
    @children = []
  end

  def children
    @children.dup
  end

  def add_child(new_child)
    children << new_child
    new_child.parent = self
  end

  def remove_child(child)
    children.delete(child)
    child.parent = nil
  end

  protected
  def parent=(parent)
    @parent = parent
  end
end
