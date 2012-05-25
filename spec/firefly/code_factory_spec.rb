require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "CodeFactory" do

  describe "next!" do
    it "should return the next sequential code_count" do
      Firefly::CodeFactory.order = :sequential
      current_count = Firefly::CodeFactory.first.count
      expected_code = Firefly::Base62.encode(current_count + 1)
      Firefly::CodeFactory.next_code!.should eql(expected_code)
    end

    it "should return the next random code_count" do
      Firefly::CodeFactory.order = :random
      current_count = Firefly::CodeFactory.first.count
      expected_code = Firefly::Base62.encode(current_count + 1)
      Firefly::CodeFactory.next_code!.should_not eql(expected_code)
    end
  end
end
