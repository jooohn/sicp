require 'set'
class Pair
  attr_accessor :car, :cdr
  def initialize(car, cdr)
    @car = car
    @cdr = cdr
  end
end

def cons(a, b)
  Pair.new(a, b)
end

def count_pairs(x)
  if x.is_a?(Pair)
    count_pairs(x.car) + count_pairs(x.cdr) + 1
  else
    0
  end
end

def count_pairs_2(x, known = Set.new)
  if x.is_a?(Pair) && !known.include?(x)
    known << x
    count_pairs_2(x.car, known) + count_pairs_2(x.cdr, known) + 1
  else
    0
  end
end

def safe_eval(*args)
  send(*args)
rescue Exception => e
  e.message
end

# lists
  a1 = cons(:a, :b)
  b1 = cons(:c, :d)
  l1 = cons(a1, b1)

  a2 = cons(:a, :b)
  b2 = cons(a2, :c)
  l2 = cons(a2, b2)

  a3 = cons(:a, :b)
  b3 = cons(a3, a3)
  l3 = cons(b3, b3)

  a4 = cons(:a, :b)
  b4 = cons(:b, a4)
  a4.cdr = b4
  l4 = cons(a4, b4)

def run(count_method)
  puts safe_eval(count_method, (cons(a1, b1)))

  puts safe_eval(count_method, (cons(a2, b2)))
  puts safe_eval(count_method, (cons(b3, b3)))
  puts safe_eval(count_method, (cons(a4, b4)))
end

[:count_pairs, :count_pairs_2].each do |count_method|
  puts "##{count_method}"
  [l1, l2, l3, l4].each do |list|
    puts safe_eval(count_method, list)
  end
  puts
end

def recursive?(x, memo = Set.new)
  case
  when memo.include?(x)
    true
  when x.is_a?(Pair)
    memo << x
    recursive?(x.cdr, memo)
  else
    false
  end
end

puts '#recursive?'
[l1, l2, l3, l4].each do |list|
  puts recursive? list
end
