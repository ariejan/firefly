require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Base62 encoding/decoding" do
  [
    [        1,     "1"],
    [       10,     "a"],
    [       61,     "Z"],
    [       62,    "10"],
    [       63,    "11"],
    [      124,    "20"],
    [200000000, "dxb8s"]
  ].each do |input, output|
    it "should encode #{input} correctly to #{output}" do
      Firefly::Base62.encode(input).should eql(output)
    end

    it "should decode correctly" do
      Firefly::Base62.decode(output).should eql(input)
    end
  end
end
