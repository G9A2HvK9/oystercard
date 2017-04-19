require "oystercard"

describe Oystercard do

  describe ".new(balance)" do
    it "should be an instance of the Oystercard class" do
      expect(subject).to be_a Oystercard
    end
    it "should have two attributes known as :balance and :in_transit" do
      expect(Oystercard.new).to have_attributes(:balance => 0, :in_transit => false)
    end
    context "when balance attribute is left as the default value" do
      it "should have a balance of 0" do
        expect(Oystercard.new).to have_attributes(:balance => 0)
      end
    end
    context "when balance attribute is made to equal 20" do
      it "should have a balance of 20" do
        expect(Oystercard.new(20)).to have_attributes(:balance => 20)
      end
    end
  end

  describe ".top_up(value)" do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    context "when top_up(amount) is equal to 5" do
      it "should increase balance by 5" do
        expect{ subject.top_up(5) }.to change{ subject.balance }.by(5)
      end
    end
    context "when top_up(amount) is equal to default" do
      it "should not change the balance" do
        expect { subject.top_up }.to_not change{ subject.balance }
      end
    end
    context "when balance is 0 and you top up 91" do
      it "should raise an error" do
        expect{ subject.top_up(91) }.to raise_error "Your balance cannot exceed #{MAX_BALANCE}. Your current balance is #{subject.balance}"
      end
    end
    context "when balance is MAX_BALANCE (#{MAX_BALANCE}) and you top up by 1" do
      it "should raise an error" do
        subject.top_up(::MAX_BALANCE)
        expect{ subject.top_up(1) }.to raise_error "Your balance cannot exceed #{MAX_BALANCE}. Your current balance is #{subject.balance}"
      end
    end
  end

  describe ".deduct(amount)" do
    it { is_expected.to respond_to(:deduct).with(1).argument }
    context "when deduct(amount) is equal to 5" do
      it "should decrease balance by 5" do
        expect{ subject.deduct(5) }.to change{ subject.balance }.by(-5)
      end
    end
    context "when deduct(amount) is equal to default" do
      it "should not change the balance" do
        expect{ subject.deduct }.to_not change{ subject.balance }
      end
    end
  end

  describe ".touch_in" do
    it { is_expected.to respond_to(:touch_in) }
    context "when @in_transit is equal to false" do
      it "changes the value of @in_transit from false to true" do
        subject.top_up(::MIN_BALANCE)
        expect{ subject.touch_in }.to change{ subject.in_transit }.from(false).to(true)
      end
    end
    context "when @in_transit is equal to true" do
      it "raises an error message" do
        subject.top_up(::MIN_BALANCE)
        subject.touch_in
        expect{ subject.touch_in }.to raise_error("You are already in transit; please touch out before beginning a new journey.")
      end
    end
    context "when @balance is less than #{MIN_BALANCE}" do
      it "raises an error message" do
        subject.top_up(::MIN_BALANCE - 0.01)
        expect{ subject.touch_in }.to raise_error "You don't have sufficient funds. Please top up your card."
      end
    end
  end

  describe ".touch_out" do
    it { is_expected.to respond_to(:touch_out) }
    context "when @in_transit is equal to true" do
      it "changes the value of @in_transit from true to false" do
        subject.top_up(::MIN_BALANCE)
        subject.touch_in
        expect{subject.touch_out}.to change{ subject.in_transit }.from(true).to(false)
      end
    end
    context "when @in_transit is equal to true" do
      it "decrease the @balance on the card by #{MIN_FARE}" do
        subject.top_up(::MIN_FARE + ::MIN_BALANCE)
        subject.touch_in
        expect{ subject.touch_out }.to change{ subject.balance }.by(-::MIN_FARE)
      end
    end
    context "when @in_transit is equal to false" do
      it "should not change the value of balance" do
        subject.top_up(::MIN_FARE + ::MIN_BALANCE)
        expect{ subject.touch_out }.not_to change{ subject.balance }
      end
    end
  end

  #describe ".add_money" do
  #  it { is_expected.to respond_to :add_money }
  #  it { is_expected to  @balance }
  #end

end
