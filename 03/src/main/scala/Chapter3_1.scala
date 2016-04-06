package q.scala

import scala.util.Try

object Chapter3_1 {

  def q3_1 = {
    def makeAccumulator(init: Int): (Int) => Int = {
      var current = init
      (num: Int) => {
        current = current + num
        current
      }
    }

    val a = makeAccumulator(5)
    println(a(10))
    println(a(10))
  }

  def q3_2 = {
    trait MonitoredFunc[A, B] {
      def apply(a: A): B
      def howManyCalls: Int
      def resetCount: Unit
    }
    def makeMonitored[A, B](func: (A) => B): MonitoredFunc[A, B] = {
      var counter = 0
      new MonitoredFunc[A, B] {
        def apply(a: A) = {
          counter += 1
          func(a)
        }
        def howManyCalls = counter
        def resetCount = counter = 0
      }
    }

    val s = makeMonitored(Math.sqrt)
    println(s(100))
    println(s.howManyCalls)
    println(s(100))
    println(s.howManyCalls)
    s.resetCount
    println(s.howManyCalls)
  }

  def q3_3 = q3_4

  def q3_4 = {
    def makeAccount(balance: Int, password: Symbol) = {
      var _balance = balance
      var failedCount = 0
      def _withDraw(amount: Int) =
        if (_balance >= amount) {
          _balance -= amount
          _balance
        } else {
          throw new Error("Incorrect funds")
        }
      def _deposit(amount: Int) = {
        _balance += amount
        _balance
      }

      new Account {
        def withDraw(amount: Int, p: Symbol) = tryWithPassword(() => _withDraw(amount), p)
        def deposit(amount: Int, p: Symbol) = tryWithPassword(() => _deposit(amount), p)

        private def tryWithPassword[A](func: () => A, p: Symbol) = Try {
          if (p == password) {
            failedCount = 0
            func()
          } else {
            failedCount += 1
            if (7 <= failedCount) {
              throw new Error("Call the police!")
            } else {
              throw new Error("Incorrect password.")
            }
          }
        }
      }
    }

    val account = makeAccount(100, 'hoge)
    println(account.withDraw(40, 'hoge))
    1 to 8 foreach { _ =>
      println(account.deposit(50, 'fuga))
    }
  }

  trait Account {
    def withDraw(amount: Int, password: Symbol): Try[Int]
    def deposit(amount: Int, password: Symbol): Try[Int]
  }

}
