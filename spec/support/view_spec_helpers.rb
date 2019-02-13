module ViewSpecHelpers
  module ControllerViewHelpers
    def current_disclosure_check
      raise 'Stub `current_disclosure_check` if you want to test the behavior.'
    end
  end

  def initialize_view_helpers(view)
    view.extend ControllerViewHelpers
  end
end
