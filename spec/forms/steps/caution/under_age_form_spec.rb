require 'spec_helper'

RSpec.describe Steps::Caution::UnderAgeForm do
  it_behaves_like 'a yes-no question form', attribute_name: :under_age
end
