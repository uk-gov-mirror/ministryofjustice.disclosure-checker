class ChecksController < ApplicationController
  before_action :check_disclosure_check_presence

  def create
    if check_group_id
      # add another conviction in existing proceedings
      initialize_disclosure_check(
        navigation_stack: navigation_stack,
        kind: CheckKind::CONVICTION.value,
        check_group: check_group
      )

      redirect_to edit_steps_check_under_age_path
    else
      # add another caution or conviction in new proceedings
      initialize_disclosure_check(
        navigation_stack: navigation_stack,
        disclosure_report: current_disclosure_report
      )

      redirect_to edit_steps_check_kind_path
    end
  end

  private

  def check_group_id
    params[:check_group_id]
  end

  def check_group
    current_disclosure_report.check_groups.find(check_group_id)
  end

  # New checks created through this controller will start
  # with the following paths in the stack.
  def navigation_stack
    [steps_check_check_your_answers_path]
  end
end
