require 'spec_helper'

describe CallsController do

  fixtures :accounts

  let(:token) do
    double(
      resource_owner_id: accounts(:alice).id,
      scopes: Doorkeeper::OAuth::Scopes.from_string('voice'),
      accessible?: true
    )
  end

  describe "GET 'index'" do
    fixtures :calls

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

      it 'returns http success' do
        get :index, format: :json
        expect(response).to be_success
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

  describe "POST 'create'" do

    context 'when not authenticated' do
      it 'returns http unauthorized' do
        post :create, format: :json
        expect(response.code).to eq('401')
      end
    end

    context 'when authenticated' do
      before do
        allow(controller).to receive(:doorkeeper_token) { token }
      end

      it 'returns http success' do
        post :create, to: 'sip/user1', format: :json
        expect(response).to be_success
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
        it 'returns http unprocessable entity' do
          post :create, format: :json
          expect(response.code).to eq('422')
        end

        it 'renders an error message' do
          post :create, format: :json
          expect(response.body).to eq({errors: "Validation failed: To can't be blank"}.to_json)
        end
      end

      context 'performance' do
        it 'should be fast' do
          expect(
            Benchmark.realtime do
              post :create, to: 'sip/user1', format: :json
            end
          ).to be < 0.1
        end
      end
    end

  end

end
