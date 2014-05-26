require 'spec_helper'

describe ActiveCallsController do

  set_fixture_class oauth_applications: Doorkeeper::Application
  fixtures :oauth_applications

  let(:application) do
    oauth_applications(:alice)
  end

  let(:token) do
    double(
      accessible?: true,
      application_id: application.id,
      application: application
    )
  end

  describe "GET 'index'" do
    fixtures :active_calls

    context 'when not authenticated' do
      it 'returns http unauthorized' do
        get :index, format: :json
        expect(response.code).to eq('401')
      end
    end

    context 'when authenticated' do
      before do
        allow(controller).to receive(:doorkeeper_token) { token }
      end

      it "returns http success" do
        get :index, format: :json
        expect(response).to be_success
        expect(response.code).to eq('200')
      end

      it 'renders the index template' do
        get :index, format: :json
        expect(response).to render_template('index')
      end

      it "assigns the account's active calls to @active_calls" do
        active_calls(:user1).update_attribute(:account_id, application.id)
        get :index, format: :json
        expect(assigns(:active_calls)).to eq([ active_calls(:user1) ])
      end
    end
  end

end
