require_relative 'linked_list'

class Stack < LinkedList
  attr_reader :data

  def initialize
      @data = LinkedList.new
  end

  def to_a
    array = []
    @data.each do |node|
      array << node.value
      node = node.next_node
    end
    array
  end

  # Push an item onto the stack
  def push(element)
    @data.add_element element
  end

  # Pop an item off the stack.  
  # Remove the last item that was pushed onto the
  # stack and return it to the user
  def pop!
    return nil if @data.empty?

    last_node = @data.tail
    second_to_last = @data.head
    @data.each do |node|
      second_to_last = node if node.next_node
    end

    (last_node == second_to_last) ? @data = LinkedList.new : second_to_last.next_node = nil
    last_node.value
  end

  def reverse
    raise NoMethodError.new('Stacks can not be reversed.')
  end
end