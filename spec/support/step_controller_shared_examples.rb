require 'rails_helper'

RSpec.shared_examples 'a generic step controller' do |form_class, decision_tree_class|
  describe '#update' do
    let(:form_object) { instance_double(form_class, attributes: { foo: double }) }
    let(:form_class_params_name) { form_class.name.underscore }
    let(:expected_params) { { form_class_params_name => { foo: 'bar' } } }

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

    context 'when the disclosure check is in progress' do
      let(:existing_case) { DisclosureCheck.create(status: :in_progress) }

      before do
        allow(form_class).to receive(:new).and_return(form_object)
      end

      context 'when the form saves successfully' do
        before do
          expect(form_object).to receive(:save).and_return(true)
        end

        let(:decision_tree) { instance_double(decision_tree_class, destination: '/expected_destination') }

        it 'asks the decision tree for the next destination and redirects there' do
          expect(decision_tree_class).to receive(:new).and_return(decision_tree)
          put :update, params: expected_params, session: { disclosure_check_id: existing_case.id }
          expect(subject).to redirect_to('/expected_destination')
        end
      end

      context 'when the form fails to save' do
        before do
          expect(form_object).to receive(:save).and_return(false)
        end

        it 'renders the question page again' do
          put :update, params: expected_params, session: { disclosure_check_id: existing_case.id }
          expect(subject).to render_template(:edit)
        end
      end
    end
  end
end

RSpec.shared_examples 'a starting point step controller' do
  describe '#edit' do
    context 'when no case exists in the session yet' do
      it 'responds with HTTP success' do
        get :edit
        expect(response).to be_successful
      end

      it 'creates a new case' do
        expect { get :edit }.to change { DisclosureCheck.count }.by(1)
      end

      it 'sets the case ID in the session' do
        expect(session[:disclosure_check_id]).to be_nil
        get :edit
        expect(session[:disclosure_check_id]).not_to be_nil
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { DisclosureCheck.create(navigation_stack: ['/not', '/empty']) }

      it 'does not create a new case' do
        expect {
          get :edit, session: { disclosure_check_id: existing_case.id }
        }.to_not change { DisclosureCheck.count }
      end

      it 'responds with HTTP success' do
        get :edit, session: { disclosure_check_id: existing_case.id }
        expect(response).to be_successful
      end

      it 'does not change the case ID in the session' do
        get :edit, session: { disclosure_check_id: existing_case.id }
        expect(session[:disclosure_check_id]).to eq(existing_case.id)
      end

      it 'does not change any existing navigation' do
        get :edit, session: { disclosure_check_id: existing_case.id }
        existing_case.reload

        expect(existing_case.navigation_stack).to eq(['/not', '/empty', controller.request.fullpath])
      end
    end
  end
end

RSpec.shared_examples 'an intermediate step controller' do |form_class, decision_tree_class|
  include_examples 'a generic step controller', form_class, decision_tree_class

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
end

RSpec.shared_examples 'an intermediate step controller without update' do
  context '#update' do
    it 'raises an exception' do
      expect { put :update }.to raise_error(AbstractController::ActionNotFound)
    end
  end

  describe '#edit' do
    context 'when no case exists in the session yet' do
      it 'raises an exception' do
        expect { get :edit }.to raise_error(RuntimeError)
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
end

RSpec.shared_examples 'a show step controller' do
  describe '#show' do
    context 'when no case exists in the session' do
      before do
        # Needed because some specs that include these examples stub current_disclosure_check,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_disclosure_check).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        get :show
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { DisclosureCheck.create }

      it 'responds with HTTP success' do
        get :show, session: { disclosure_check_id: existing_case.id }
        expect(response).to be_successful
      end
    end
  end
end

RSpec.shared_examples 'a completion step controller' do
  describe '#show' do
    let(:current_disclosure_check) {
      build(:disclosure_check, status: status, navigation_stack: %w(/not /empty))
    }
    let(:current_disclosure_report) { DisclosureReport.new(status: status) }
    let(:status) { :in_progress }

    context 'when no disclosure check exists in the session' do
      before do
        # Needed because some specs that include these examples stub current_disclosure_check,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_disclosure_check).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        get :show
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    describe 'marking as completed' do
      before do
        allow(controller).to receive(:current_disclosure_check).and_return(current_disclosure_check)
        allow(controller).to receive(:current_disclosure_report).and_return(current_disclosure_report)
      end

      context 'when the report is not already marked as `completed`' do
        it 'calls the `mark_report_completed` method' do
          expect(controller).to receive(:mark_report_completed)
          get :show, session: { disclosure_check_id: '123' }
        end

        it 'calls the `purge_incomplete_checks` method' do
          expect(controller).to receive(:mark_report_completed)

          expect(controller).to receive(:purge_incomplete_checks)
          get :show, session: { disclosure_check_id: '123' }
        end
      end

      context 'when the report is already marked as `completed`' do
        let(:status) { :completed }

        it 'does not call the `mark_report_completed` method' do
          expect(controller).not_to receive(:mark_report_completed)
          get :show, session: { disclosure_check_id: '123' }
        end

        it 'does not call the `purge_incomplete_checks` method' do
          expect(controller).not_to receive(:purge_incomplete_checks)
          get :show, session: { disclosure_check_id: '123' }
        end
      end
    end
  end
end
