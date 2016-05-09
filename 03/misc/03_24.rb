class Pair
  attr_accessor :car, :cdr
  def initialize(car, cdr)
    @car = car
    @cdr = cdr
  end

  def inspect
    "(#{car}, #{cdr})"
  end

  def to_s
    inspect
  end
end

def list(*args)
  args.reverse.inject(nil) { |memo, item|
    Pair.new(item, memo)
  }
end

def let(value, &block)
  yield value
end

def make_table(same_key)

  let(Pair.new(:_table_, nil)) { |local_table|
    assoc = lambda { |key, records|
      case
      when records.nil? then false
      when same_key.call(key, records.car.car) then records.car
      else assoc.call(key, records.cdr)
      end
    }

    lookup = lambda { |keys|
      lookup_inner = lambda { |remaining, subtable|
        if remaining.nil?
          subtable
        else
          let(assoc.call(remaining.car, subtable)) { |sub|
            if sub
              lookup_inner.call(remaining.cdr, sub.cdr)
            else
              false
            end
          }
        end

      }
      lookup_inner.call(keys, local_table.cdr)
    }

    insert = lambda { |keys, value|
      insert_inner = lambda { |remaining, pair|
        if remaining.nil?
          pair.cdr = value
        else
          let(assoc.call(remaining.car, pair.cdr)) { |sub|
            if sub
              insert_inner.call(remaining.cdr, sub)
            else
              pair.cdr = Pair.new(Pair.new(remaining.car, nil), pair.cdr)
              insert_inner.call(remaining.cdr, pair.cdr.car)
            end
          }
        end
      }
      insert_inner.call(keys, local_table)
      :ok
    }

    lambda { |m|
      case m
      when :lookup_proc then lookup
      when :insert_proc! then insert
      else fail 'Unknown operation'
      end
    }
  }
end

table = make_table(->(a, b) { a == b })
p table.call(:lookup_proc).call(list(:a, :b, :c))
p table.call(:insert_proc!).call(list(:a, :b, :c), 3)
p table.call(:lookup_proc).call(list(:a, :b, :c))
p table.call(:insert_proc!).call(list(:a, :b, :d), 4)
p table.call(:lookup_proc).call(list(:a, :b, :c))
p table.call(:lookup_proc).call(list(:a, :b, :d))
