require 'rails_helper'

RSpec.describe Steps::Mvp::InfoController, type: :controller do
  let(:form_class) { Steps::Mvp::InfoForm }
  let(:decision_tree_class) { MvpDecisionTree }

  let(:participant) { Participant.new }
  let(:reference) { 'test' }

  # Avoid saving to the database
  before do
    allow(Participant).to receive(:find_or_create_by).with(reference: reference).and_return(participant)
    allow(participant).to receive(:save).and_return(true)
  end

  describe '#edit' do
    let(:expected_params) { { id: reference } }

    it 'responds with HTTP success' do
      get :edit, params: expected_params
      expect(response).to be_successful
    end

    it 'raises an error if the reference is not present' do
      expect {
        get :edit
      }.to raise_error(RuntimeError, "Participant reference not found: ''")
    end

    it 'raises an error if the reference is invalid' do
      expect {
        get :edit, params: { id: 'foobar' }
      }.to raise_error(RuntimeError, "Participant reference not found: 'foobar'")
    end

    it 'increments the access counter' do
      expect {
        get :edit, params: expected_params
      }.to change { participant.access_count }.by(1)
    end
  end

  describe '#update' do
    let(:form_object) { instance_double(form_class, attributes: { foo: double }) }
    let(:form_class_params_name) { form_class.name.underscore }
    let(:expected_params) { { form_class_params_name => { foo: 'bar' }, id: reference } }

    before do
      allow(form_class).to receive(:new).and_return(form_object)
    end

    it 'raises an error if the reference is not present' do
      expect {
        put :update
      }.to raise_error(RuntimeError)
    end

    context 'when the form saves successfully' do
      before do
        expect(form_object).to receive(:save).and_return(true)
      end

      let(:decision_tree) { instance_double(decision_tree_class, destination: '/expected_destination') }

      it 'asks the decision tree for the next destination and redirects there' do
        expect(decision_tree_class).to receive(:new).and_return(decision_tree)
        put :update, params: expected_params
        expect(subject).to redirect_to('/expected_destination')
      end
    end

    context 'when the form fails to save' do
      before do
        expect(form_object).to receive(:save).and_return(false)
      end

      it 'renders the question page again' do
        put :update, params: expected_params
        expect(subject).to render_template(:edit)
      end
    end
  end
end
