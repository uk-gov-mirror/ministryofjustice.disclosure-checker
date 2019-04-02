require 'spec_helper'

RSpec.describe Steps::Conviction::UnderAgeConvictionForm do
  it_behaves_like 'a yes-no question form', attribute_name: :under_age_conviction
end
