require 'rails_helper'

RSpec.describe Steps::Check::CheckYourAnswersController, type: :controller do
  describe '#show' do
    let(:disclosure_check) { build(:disclosure_check) }

    before do
      allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
    end

    context 'when there is no disclosure check in the session' do
      before do
        allow(controller).to receive(:current_disclosure_check).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        get :show
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'for a caution' do
      let(:kind) { 'caution' }

      it 'render template' do
        get :show

        expect(response).to render_template(:show)
      end
    end

    context 'for a conviction' do
      let(:kind) { 'conviction' }

      before do
        allow_any_instance_of(
          ConvictionResultPresenter
        ).to receive(:expiry_date).and_return(Date.yesterday)
      end

      it 'render template' do
        get :show

        expect(response).to render_template(:show)
      end
    end
  end
end
