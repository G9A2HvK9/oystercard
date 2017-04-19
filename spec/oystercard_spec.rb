require "oystercard"

describe Oystercard do

  describe ".new(balance)" do
    it "should be an instance of the Oystercard class" do
      expect(subject).to be_a Oystercard
    end
    it "should have an attribute known as :balance" do
      expect(Oystercard.new).to have_attributes(:balance => 0)
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
    it { is_expected.to respond_to(:touch_in).with(1).argument }
    context "when already in_transit" do
      it "raises an error message" do
        subject.top_up(::MIN_BALANCE)
        subject.touch_in("East") # in_transit will be true
        expect{ subject.touch_in }.to raise_error("You are already in transit; please touch out before beginning a new journey.")
      end
    end
    context "when @balance is less than #{MIN_BALANCE}" do
      it "raises an error message" do
        subject.top_up(::MIN_BALANCE - 0.01)
        expect{ subject.touch_in }.to raise_error "You don't have sufficient funds. Please top up your card."
      end
    end
    context "when journey_start is equal to default" do
      it "it should be equal to nil" do
        subject.top_up(::MIN_BALANCE + ::MIN_FARE)
        subject.touch_in
        expect( subject.journey_start ).to eq nil
      end
    end
    context "when touching_in at Aldgate" do
      it "let's journey_start equal Aldgate" do
        subject.top_up(::MIN_BALANCE + ::MIN_FARE)
        subject.touch_in("Aldgate")
        expect( subject.journey_start ).to eq("Aldgate")
      end
      it "records Aldgate as entry station" do
        subject.top_up(::MIN_BALANCE + ::MIN_FARE)
        subject.touch_in("Aldgate")
        expect(subject.current_journey[:Entry_Station]).to eq "Aldgate"
      end
    end
  end

  describe ".touch_out" do
    it { is_expected.to respond_to(:touch_out).with(1).argument }
    context "when in_transit" do
      it "decrease the @balance on the card by #{MIN_FARE}" do
        subject.top_up(::MIN_FARE + ::MIN_BALANCE)
        subject.touch_in("Aldgate") # indicating in_transit is true
        expect{ subject.touch_out }.to change{ subject.balance }.by(-::MIN_FARE)
      end
    end
    context "when in_transit is false" do
      it "should not change the value of balance" do
        subject.top_up(::MIN_FARE + ::MIN_BALANCE)
        subject.touch_in("East")
        subject.touch_out("Aldgate")
        expect{ subject.touch_out }.not_to change{ subject.balance }
      end
    end
    context "when journey_end is equal to default" do
      it "it should be equal to nil" do
        subject.touch_out
        expect( subject.journey_end ).to eq nil
      end
    end
    context "when touching_out at Aldgate" do
      it "let's journey_end equal Aldgate" do
        subject.touch_out("Aldgate")
        expect( subject.journey_end ).to eq("Aldgate")
      end
      it "records Aldgate as exit station" do
        subject.top_up(::MIN_BALANCE + ::MIN_FARE)
        subject.touch_in("East")
        subject.touch_out("Aldgate")
        expect(subject.current_journey[:Exit_station]).to eq "Aldgate"
      end
    end
    context "when touching in at 'East' and touching out at 'West'" do
      it "records whole journey to journey_history" do
        subject.top_up(::MIN_BALANCE + ::MIN_FARE)
        subject.touch_in("East")
        subject.touch_out("West")
        expect(subject.journey_history).to include({:Entry_Station => "East", :Exit_station => "West"})
      end
    end
  end

  #describe ".add_money" do
  #  it { is_expected.to respond_to :add_money }
  #  it { is_expected to  @balance }
  #end

end
