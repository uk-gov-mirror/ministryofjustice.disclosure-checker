require 'rails_helper'

RSpec.describe Steps::Check::CautionOrConvictionController, type: :controller do
  describe '#edit' do
    context 'when no case exists in the session yet' do
      before do
        # Needed because some specs that include these examples stub current_disclosure_check,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_disclosure_check).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        get :edit
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { DisclosureCheck.create(status: :in_progress) }

      it 'responds with HTTP success' do
        get :edit, session: { disclosure_check_id: existing_case.id }
        expect(response).to be_successful
      end
    end
  end

  describe '#update' do
    let(:add_caution_or_conviction) { 'yes' }
    let(:expected_params) do
      {
        steps_check_caution_or_conviction_form: {
          add_caution_or_conviction: add_caution_or_conviction
        }
      }
    end

    context 'when there is no case in the session' do
      before do
        # Needed because some specs that include these examples stub current_disclosure_check,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_disclosure_check).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        put :update, params: expected_params
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end


    context 'when there is a disclosure check in progress' do
      let(:existing_case) { DisclosureCheck.create(status: :in_progress) }

      context 'when `add_caution_or_conviction` is yes' do
        it 'redirect user to steps/check/kind page' do
          put :update, params: expected_params, session: { disclosure_check_id: existing_case.id }

          expect(response).to redirect_to(edit_steps_check_kind_path)
        end
      end

      context 'when `add_caution_or_conviction` is no' do
        let(:add_caution_or_conviction) { 'no' }

        it 'redirect user to steps/check/kind page' do
          put :update, params: expected_params, session: { disclosure_check_id: existing_case.id }

          expect(response).to redirect_to(steps_check_results_path(show_results: true))
        end
      end
    end
  end
end
