class TreeNode
  attr_accessor :value
  attr_reader :parent

  def initialize(value = nil)
    @value = value

    @parent = parent
    @children = [nil, nil]
  end

  def left_child
    @children[0]
  end

  def right_child
    @children[1]
  end

  def children
    @children.dup
  end

  def left_child=(child)
    set_child(child, 0)
  end

  def right_child=(child)
    set_child(child, 1)
  end

  def set_child(new_child, position)
    raise IllegalArgumentError.new("invalid position") unless (0...@children.count).include?(position)

    old_child = @children[position]

    old_child.parent = nil if old_child
    new_child.parent = self if new_child

    @children[position] = new_child
  end

  def dfs(target)
    return self if value == target

    @children.each do |child|
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

  protected
  def parent=(parent)
    @parent = parent
  end
end
