require 'spec_helper'

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
    it "encodes #{input} into #{output}" do
      Base62.encode(input).must_equal output
    end

    it "decode #{output} into #{input}" do
      Base62.decode(output).must_equal input
    end
  end
end
