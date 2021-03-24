require 'spec_helper'

RSpec.describe Steps::Check::CautionOrConvictionForm do
  it_behaves_like 'a yes-no question form', attribute_name: :add_caution_or_conviction
end
