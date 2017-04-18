require_relative "parameters"

class Oystercard
attr_reader :balance

  def initialize(balance = 0)
    @balance = balance
  end

  def top_up(amount = 0)
    raise "Your balance cannot exceed #{MAX_BALANCE}. Your current balance is #{@balance}" if @balance + amount > MAX_BALANCE
    @balance += amount
  end

  def deduct(amount = 0)
    @balance -= amount
  end

end
