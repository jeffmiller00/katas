class LinkedList
  attr_accessor :head

  def initialize *init_values
    @head = current_node = nil
    # I know I'm using an array here to initialize the linked list...
    # ...I didn't think I had to handicap myself all the way through the excercise
    init_values.reverse.each do |value|
      @head = LinkedListNode.new(value, @head)
    end
  end

  def empty?
    !!@head.nil?
  end

  def add_element(value)
    if self.empty?
      @head = LinkedListNode.new(value)
    else
      self.tail.next_node = LinkedListNode.new(value)
    end
  end

  def tail
    last_node = nil
    self.each do |node|
      last_node = node
    end
    last_node
  end

  # print_values belongs to the list not the node class,
  #   but left implementation from problem in the Node
  def print_values
    LinkedListNode.print_values @head
  end

  def each
    if block_given?
      node = @head

      while node do
        yield node
        node = node.next_node
      end
    else
      super
    end
  end

  def reverse
    node = @head
    stack = Stack.new

    self.each do |node|
      stack.push node.value
      node = node.next_node
    end

    reverse_list = LinkedList.new
    while new_element = stack.pop! do
      reverse_list.add_element new_element
    end
    reverse_list
  end

  def reverse!
    node = @head
    previous = nil
    while node do
      n = node.next_node
      @head = node if node.next_node.nil?
      node.next_node = previous
      previous = node
      node = n
    end
    self
  end

  def has_cycle?
    loop_found = false

    # Both start at the head
    tortoise = hare = @head
    while hare do
      # Hare moves one step
      hare = hare.next_node

      if hare
        # If hare exists, it moves another step and tortoise moves one
        #  thus hare moving twice as fast as tortoise.
        hare = hare.next_node
        tortoise = tortoise.next_node
      end

      if tortoise == hare
        loop_found = true
        break
      end
    end

    loop_found
  end
end