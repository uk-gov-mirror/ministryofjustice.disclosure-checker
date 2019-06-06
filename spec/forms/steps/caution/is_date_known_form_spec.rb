require 'spec_helper'

RSpec.describe Steps::Caution::IsDateKnownForm do
  it_behaves_like 'a yes-no question form', attribute_name: :is_date_known
end
