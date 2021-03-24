class BaseDecisionTree
  class InvalidStep < RuntimeError; end

  include ApplicationHelper

  attr_reader :disclosure_check, :record, :step_params,
              :as, :next_step

  def initialize(disclosure_check:, record: nil, step_params: {}, **options)
    @disclosure_check = disclosure_check
    @record = record
    @step_params = step_params
    @as = options[:as]
    @next_step = options[:next_step]
  end

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

  def results
    disclosure_check.completed!

    show('/steps/check/results')
  end
end
