require 'spec_helper'

RSpec.describe Steps::Caution::ConditionCompliedForm do
  it_behaves_like 'a yes-no question form', attribute_name: :condition_complied
end
