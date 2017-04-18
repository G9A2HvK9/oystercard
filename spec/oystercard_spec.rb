require "oystercard"

describe Oystercard do

  describe "Oytercard.new(balance)" do
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

  #describe ".add_money" do
  #  it { is_expected.to respond_to :add_money }
  #  it { is_expected to  @balance }
  #end

end
