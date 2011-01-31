require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "CodeFactory" do

  describe "next!" do
    it "should return the next code_count" do
      current_count = Firefly::CodeFactory.first.count
      expected_code = Firefly::Base62.encode(current_count + 1)
      Firefly::CodeFactory.next_code!.should eql(expected_code)
    end
  end
end
