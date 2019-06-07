class BaseDecisionTree
  class InvalidStep < RuntimeError; end

  include ApplicationHelper

  attr_reader :disclosure_check, :record, :step_params, :as, :next_step

  # rubocop:disable Naming/UncommunicativeMethodParamName
  def initialize(disclosure_check:, record: nil, step_params: {}, as: nil, next_step: nil)
    @disclosure_check = disclosure_check
    @record = record
    @step_params = step_params
    @as = as
    @next_step = next_step
  end
  # rubocop:enable Naming/UncommunicativeMethodParamName

  private

  def step_value(attribute_name)
    step_params.fetch(attribute_name)
  end

  def step_name
    (as || step_params.keys.first).to_sym
  end

  def show(step_controller)
    { controller: step_controller, action: :show }
  end

  def edit(step_controller, params = {})
    { controller: step_controller, action: :edit }.merge(params)
  end
end
