require 'spec_helper'

describe CallsController do

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

  describe 'GET /calls' do
    fixtures :calls

    context 'when not authenticated' do
      it 'responds with an HTTP 401 status code' do
        get :index, format: :json
        expect(response.code).to eq('401')
      end
    end

    context 'when authenticated' do
      before do
        allow(controller).to receive(:doorkeeper_token) { token }
      end

      it 'responds successfully with an HTTP 200 status code' do
        get :index, format: :json
        expect(response).to be_successful
        expect(response.code).to eq('200')
      end

      it 'renders the index template' do
        get :index, format: :json
        expect(response).to render_template('index')
      end

      it "assigns the account's call details to @calls" do
        get :index, format: :json
        expect(assigns(:calls)).to eq([ calls(:answered) ])
      end
    end

  end

  describe 'POST /calls' do

    context 'when not authenticated' do
      it 'responds with an HTTP 401 status code' do
        post :create, format: :json
        expect(response.code).to eq('401')
      end
    end

    context 'when authenticated' do
      before do
        allow(controller).to receive(:doorkeeper_token) { token }
      end

      it 'responds successfully with an HTTP 200 status code' do
        post :create, to: 'sip/user1', format: :json
        expect(response).to be_successful
        expect(response.code).to eq('200')
      end

      it 'assigns a "call successful" message to @message' do
        post :create, to: 'sip/user1', format: :json
        expect(assigns(:message)).to eq(I18n.t(:successful, scope: [ :calls, :create ]))
      end

      it 'renders the create template' do
        post :create, to: 'sip/user1', format: :json
        expect(response).to render_template('create')
      end

      context 'but the request is invalid' do
        it 'responds with an HTTP 422 status code' do
          post :create, format: :json
          expect(response.code).to eq('422')
        end

        it 'renders an error message' do
          post :create, format: :json
          expect(response.body).to eq({errors: ["To can't be blank"]}.to_json)
        end
      end

      context 'performance' do
        it 'should be fast' do
          expect(
            Benchmark.realtime do
              post :create, format: :json
            end
          ).to be < 0.1
        end
      end
    end

  end

end
