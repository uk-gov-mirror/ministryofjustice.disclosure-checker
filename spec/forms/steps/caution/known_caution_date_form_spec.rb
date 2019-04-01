require 'spec_helper'

RSpec.describe Steps::Caution::KnownCautionDateForm do
  it_behaves_like 'a yes-no question form', attribute_name: :known_caution_date
end
