require 'rails_helper'

RSpec.describe Steps::Check::ResultsController, type: :controller do
  it_behaves_like 'a completion step controller'

  describe '#show' do
    let(:disclosure_check) { build(:disclosure_check) }

    before do
      allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
    end

    context 'show check your answers' do
      it 'redirect to check your answer' do
        get :show

        expect(response).to redirect_to(steps_check_check_your_answers_path)
      end
    end

    context 'show results page' do
      it 'show multiple results page' do
        get :show, params: { show_results: true }

        expect(response).to render_template(:show)
        expect(assigns[:presenter]).to be_a_kind_of(CheckAnswersPresenter)
      end
    end
  end
end
