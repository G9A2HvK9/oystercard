require "oystercard"

describe Oystercard do

  describe ".new(balance)" do
    it "should be an instance of the Oystercard class" do
      expect(subject).to be_a Oystercard
    end
    context "when balance is left as the default value" do
      it "should have a balance of 0" do
        expect(Oystercard.new(0)).to have_attributes(:balance => 0)
      end
    end
    context "when balance is made to equal 20" do
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
    context "when balance is #{MAX_BALANCE} and you top up by 1" do
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

  #describe ".add_money" do
  #  it { is_expected.to respond_to :add_money }
  #  it { is_expected to  @balance }
  #end

end
