module Steps
  module Conviction
    class CommunityOrderController < Steps::ConvictionStepController
      def edit
        @form_object = CommunityOrderForm.new(
          disclosure_check: current_disclosure_check,
          community_order: current_disclosure_check.community_order
        )
      end

      def update
        update_and_advance(CommunityOrderForm)
      end
    end
  end
end
