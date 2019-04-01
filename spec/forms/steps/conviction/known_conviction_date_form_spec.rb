require 'spec_helper'

RSpec.describe Steps::Conviction::KnownConvictionDateForm do
  it_behaves_like 'a yes-no question form', attribute_name: :known_conviction_date
end
