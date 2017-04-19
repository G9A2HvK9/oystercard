require_relative "parameters"

class Oystercard
attr_reader :balance, :journey_start, :journey_end # <-- CHANGE!

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

  def touch_in(journey_start = nil)
    raise "You are already in transit; please touch out before beginning a new journey." if in_transit?
    raise "You don't have sufficient funds. Please top up your card." if @balance < MIN_BALANCE
    @journey_end = nil
    @journey_start = journey_start
  end

  def touch_out(journey_end = nil)
    deduct(MIN_FARE) if in_transit?
    @journey_end = journey_end
    @journey_start = nil
  end

  def in_transit?
    (!@journey_start.nil? && @journey_end.nil?) ? true : false
  end

end
