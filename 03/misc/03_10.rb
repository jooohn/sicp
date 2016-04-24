require './environmental_model'
EnvironmentalModel.main {
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
