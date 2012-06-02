FactoryGirl.define do
  sequence(:real_url) { |n| "http://example-#{n}.com" }
  sequence(:fingerprint) { |n| "test#{n}" }

  factory :url do
    url { generate(:real_url) }
    fingerprint
  end
end
