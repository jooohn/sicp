class Frame < Struct.new(:binding, :parent)

  def to_s
    inspect
  end

  def inspect
    [binding, parent].compact.join("\n  extends ")
  end

  def make_child(new_binding)
    Frame.new(new_binding, self)
  end

  def set(key, value)
    binding[key] = value
  end

  def set!(key, value)
    if binding.key?(key)
      binding[key] = value
    elsif !parent.nil?
      parent.set!(key, value)
    else
      fail "'#{key}' is not defined."
    end
  end

  def get(key)
    if binding.key?(key)
      binding[key]
    elsif parent
      parent.get(key)
    else
      fail "#{key} is not defined."
    end
  end
end

class Evaluator
  attr_reader :frame

  private

  def initialize(frame)
    @frame = frame
  end

  def define(key, value)
    frame.set(key, value)
  end

  def set!(key, value)
    frame.set!(key, value)
  end

  def λ(*args, &block)
    Lambda.new(args, frame, &block)
  end

  def let(key, value, &block)
    λ(key, &block).eval(value)
  end

  def method_missing(symbol, *args)
    method_real = frame.get(symbol)
    if args.empty?
      method_real
    else
      method_real.eval(*args)
    end
  end

  class Lambda
    def initialize(args, frame, &block)
      @args = args
      @frame = frame
      @block = block
    end

    def inspect
      "lambda(#{@args.join(',')}){...}"
    end

    def eval(*call_args)
      binding = @args.zip(call_args).to_h
      eval_frame = @frame.make_child(binding)
      Evaluator.eval(eval_frame, &@block)
    end
  end

  class << self
    def eval(frame, &block)
      Evaluator.new(frame).instance_eval(&block)
    end
  end
end

GLOBAL = Frame.new({}, nil)
Evaluator.eval(GLOBAL) {
  define :make_withdraw, λ(:initial_amount) {
    let(:balance, initial_amount) {
      λ(:amount) {
        if balance >= amount
          set!(:balance, balance - amount)
          balance
        else
          fail "Insufficient funds"
        end
      }
    }
  }
  define :W1, make_withdraw(100)
  puts W1(60)
  puts W1(20)
  define :W2, make_withdraw(100)
}
