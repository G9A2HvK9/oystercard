require "station"

describe Station do
  it { is_expected.to be_a Station }
  it { is_expected.to have_attributes(:name => nil, :zone => nil) }
end
