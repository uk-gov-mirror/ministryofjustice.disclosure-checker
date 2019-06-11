require 'rails_helper'

RSpec.describe Steps::Check::ResultsController, type: :controller do
  it_behaves_like 'a completion step controller'

  describe '#show' do
    let(:disclosure_check) { build(:disclosure_check, kind: kind) }

    before do
      allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
    end

    context 'for a caution' do
      let(:kind) { 'caution' }

      it 'assigns the correct presenter' do
        get :show

        expect(response).to render_template(:show)
        expect(assigns[:presenter]).to be_a_kind_of(CautionResultPresenter)
      end
    end

    context 'for a conviction' do
      let(:kind) { 'conviction' }

      it 'assigns the correct presenter' do
        get :show

        expect(response).to render_template(:show)
        expect(assigns[:presenter]).to be_a_kind_of(ConvictionResultPresenter)
      end
    end

    context 'for an unknown kind' do
      let(:kind) { 'foobar' }

      it 'assigns the correct presenter' do
        expect { get :show }.to raise_error(TypeError)
      end
    end
  end
end
