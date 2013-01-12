require 'rspec'
require_relative 'tree_node.rb'

describe TreeNode do
  subject(:tree_node) { TreeNode.new }

  its(:parent) { should eq(nil) }
  its(:value) { should be_nil }

  it "sets value" do
    value = double("value")
    tree_node.value = value
    tree_node.value.should == value
  end

  context "with child" do
    let(:child) do
      double("child", :parent => nil, :parent= => nil)
    end

    it "sets child" do
      tree_node.left_child = child
      tree_node.left_child.should == child
    end

    it "sets new child's parent" do
      child.should_receive(:parent=).with(tree_node)
      tree_node.left_child = child
    end

    it "resets old child's parent" do
      old_child = double("old_child", :parent => nil, :parent= => nil)
      tree_node.left_child = old_child

      old_child.should_receive(:parent=).with(nil)
      tree_node.left_child = nil
    end
  end

  context "with larger tree" do
    let(:tree_node) do
      tree_node = TreeNode.new(1)
      tree_node.left_child = TreeNode.new(2)
      tree_node.left_child.left_child = TreeNode.new(3)
      tree_node.left_child.right_child = TreeNode.new(4)
      tree_node.right_child = TreeNode.new(5)

      tree_node
    end

    %w( dfs bfs ).each do |method|
      describe "##{method}" do
        it "finds target in tree" do
          tree_node.send(method, 5).should == tree_node.right_child
        end

        it "finds target deeper in tree" do
          tree_node.send(method, 4).should == tree_node.left_child.right_child
        end

        it "returns nil if target not in tree" do
          tree_node.send(method, 6).should be_nil
        end
      end
    end

    describe "#dfs" do
      it "visits nodes in right order" do
        [tree_node,
          tree_node.left_child,
          tree_node.left_child.left_child,
          tree_node.left_child.right_child,
          tree_node.right_child].each do |node|
          node.should_receive(:value).ordered
        end

        tree_node.dfs(5)
      end
    end

    describe "#bfs" do
      it "visits nodes in right order" do
        [tree_node,
          tree_node.left_child,
          tree_node.right_child,
          tree_node.left_child.left_child,
          tree_node.left_child.right_child].each do |node|
          node.should_receive(:value).ordered
        end

        tree_node.bfs(5)
      end
    end
  end
end
