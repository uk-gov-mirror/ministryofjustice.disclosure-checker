class StepController < ApplicationController
  before_action :check_disclosure_check_presence
  before_action :update_navigation_stack, only: [:show, :edit]

  private

  def update_and_advance(form_class, opts = {})
    hash = permitted_params(form_class).to_h
    record = opts[:record]

    @next_step   = params[:next_step].presence
    @form_object = form_class.new(
      hash.merge(disclosure_check: current_disclosure_check, record: record)
    )

    if @form_object.save
      destination = decision_tree_class.new(
        disclosure_check: current_disclosure_check,
        record:        record,
        step_params:   hash,
        # Used when the step name in the decision tree is not the same as the first
        # (and usually only) attribute in the form.
        as:            opts[:as],
        next_step:     @next_step
      ).destination

      redirect_to destination
    else
      render opts.fetch(:render, :edit)
    end
  end

  def permitted_params(form_class)
    params
      .fetch(form_class.model_name.singular, {})
      .permit(form_attribute_names(form_class) + additional_permitted_params)
  end

  # Some form objects might contain complex attribute structures or nested params.
  # Override in subclasses to declare any additional parameters that should be permitted.
  def additional_permitted_params
    []
  end

  def form_attribute_names(form_class)
    form_class.attribute_set.map do |attr|
      attr_name = attr.name
      primitive = attr.primitive

      primitive.eql?(Date) ? %W[#{attr_name}_dd #{attr_name}_mm #{attr_name}_yyyy] : attr_name
    end.flatten
  end

  def update_navigation_stack
    return unless current_disclosure_check

    stack_until_current_page = current_disclosure_check.navigation_stack.take_while do |path|
      path != request.fullpath
    end

    current_disclosure_check.navigation_stack = stack_until_current_page + [request.fullpath]
    current_disclosure_check.save!
  end
end
