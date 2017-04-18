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
      it "should keep the balance the same" do
        expect { subject.top_up }.to_not change{ subject.balance }
      end
    end
  end

  #describe ".add_money" do
  #  it { is_expected.to respond_to :add_money }
  #  it { is_expected to  @balance }
  #end

end
