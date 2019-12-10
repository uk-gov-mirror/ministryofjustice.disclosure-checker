require 'rails_helper'

RSpec.describe PilotController, type: :controller do
  let(:participant) { Participant.new }
  let(:reference) { 'test' }

  # Avoid saving to the database
  before do
    allow(Participant).to receive(:find_or_create_by).with(reference: reference).and_return(participant)
    allow(participant).to receive(:save).and_return(true)
  end

  describe '#show' do
    let(:expected_params) { { id: reference } }

    it 'redirects to the home page' do
      get :show, params: expected_params
      expect(response).to redirect_to(root_url)
    end

    it 'increments the access counter' do
      expect {
        get :show, params: expected_params
      }.to change { participant.access_count }.by(1)
    end

    it 'raises an error if the reference is not present' do
      expect {
        get :show, params: { id: '' }
      }.to raise_error(RuntimeError, "Participant reference not found: ''")
    end

    it 'raises an error if the reference is invalid' do
      expect {
        get :show, params: { id: 'foobar' }
      }.to raise_error(RuntimeError, "Participant reference not found: 'foobar'")
    end
  end
end
