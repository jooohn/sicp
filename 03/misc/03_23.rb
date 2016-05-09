require 'ostruct'
class Pair
  attr_accessor :car, :cdr
  def initialize(car, cdr)
    @car = car
    @cdr = cdr
  end
end

def make_queue
  front_ptr = nil
  rear_ptr = nil

  queue = OpenStruct.new
  queue.enqueue = lambda { |item|
    if front_ptr.nil?
      front_ptr = rear_ptr = Pair.new(item, nil)
    else
      rear_ptr.cdr = Pair.new(item, nil)
      rear_ptr = rear_ptr.cdr
    end
  }
  queue.dequeue = lambda {
    fail 'empty queue' if front_ptr.nil?
    item = front_ptr.car
    front_ptr = front_ptr.cdr
    rear_ptr = nil if front_ptr.nil?
    item
  }

  queue.print_queue = lambda {
    def print_queue_inner(ptr)
      if ptr.nil?
        ''
      else
        ptr.car.to_s + ' ' + print_queue_inner(ptr.cdr)
      end
    end
    puts 'queue: ' + print_queue_inner(front_ptr)
  }

  queue
end

puts
puts '### queue'
puts

queue = make_queue
queue.print_queue.call

queue.enqueue.call 1
queue.print_queue.call

queue.enqueue.call 2
queue.print_queue.call

puts queue.dequeue.call
queue.print_queue.call

puts queue.dequeue.call
queue.print_queue.call

begin
  puts queue.dequeue.call
  queue.print_queue.call
rescue => e
  puts e
end

class Deque
  def initialize
    @front = nil
    @rear = nil
  end

  def front_enqueue(item)
    @front = make_item(item, nil, @front)
    @rear = @front if @rear.nil?
  end

  def front_dequeue
    fail 'empty dequeue' if @front.nil?
    @front.cdr.cdr.cdr.car = nil unless @front.cdr.cdr.nil?
    item = @front.car
    @front = @front.cdr.cdr
    @rear = nil if @front.nil?
    item
  end

  def rear_enqueue(item)
    @rear = make_item(item, @rear, nil)
    @front = @rear if @front.nil?
  end

  def rear_dequeue
    fail 'empty dequeue' if @rear.nil?
    @rear.cdr.car.cdr.cdr = nil unless @rear.cdr.car.nil?
    item = @rear.car
    @rear = @rear.cdr.car
    @front = nil if @front.nil?
    item
  end

  def print_dequeue
    puts 'dequeue: ' + print_inner(@front)
  end

  def make_item(value, left, right)
    new_item = Pair.new(value, Pair.new(left, right))
    left.cdr.cdr = new_item unless left.nil?
    right.cdr.car = new_item unless right.nil?
    new_item
  end

  def print_inner(item)
    item.nil? ? '' : item.car.to_s + ' ' + print_inner(item.cdr.cdr)
  end
end

puts
puts '### dequeue'
puts

dequeue = Deque.new
dequeue.print_dequeue

dequeue.front_enqueue 1
dequeue.print_dequeue

dequeue.front_enqueue 2
dequeue.print_dequeue

dequeue.rear_enqueue 3
dequeue.print_dequeue

dequeue.rear_enqueue 4
dequeue.print_dequeue

puts dequeue.front_dequeue
dequeue.print_dequeue

puts dequeue.rear_dequeue
dequeue.print_dequeue

puts dequeue.front_dequeue
dequeue.print_dequeue

puts dequeue.rear_dequeue
dequeue.print_dequeue
