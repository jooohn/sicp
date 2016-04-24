require './environmental_model'
EnvironmentalModel.main {
  define :make_account, λ(:balance) {
    define :withdraw, λ(:amount) {
      if balance >= amount
        set! :balance, balance - amount
        balance
      else
        fail 'Insufficient funds'
      end
    }
    define :deposit, λ(:amount) {
      set! :balance, balance + amount
      balance
    }
    define :dispatch, λ(:m) {
      case
      when m == :withdraw then withdraw
      when m == :deposit then deposit
      else
        fail 'Unknown request: MAKE-ACCOUNT'
      end
    }
    dispatch
  }
  define :acc, make_account(50)
  puts acc(:deposit).eval(40)
  puts acc(:withdraw).eval(60)
}
