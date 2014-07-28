require 'spec_helper'

describe SoundsController do

  fixtures :accounts

  let(:token) do
    double(
      resource_owner_id: accounts(:alice).id,
      accessible?: true
    )
  end

  describe "GET 'index'" do

    context 'when not authenticated' do
      it 'returns http unauthorized' do
        get :index, format: :json
        expect(response.code).to eq('401')
      end
    end

    context 'when authenticated' do
      fixtures :sounds

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

      it "assigns the account's sound details to @sounds" do
        get :index, format: :json
        expect(assigns(:sounds)).to eq([ sounds(:ding) ])
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
        post :create, name: 'Dong', format: :json
        expect(response).to be_success
        expect(response.code).to eq('201')
      end

      it 'assigns a "sound created successfully" message to @message' do
        post :create, name: 'Dong', format: :json
        expect(assigns(:message)).to eq(I18n.t(:successful, scope: [ :sounds, :create ]))
      end

      it 'renders the show template' do
        post :create, name: 'Dong', format: :json
        expect(response).to render_template('show')
      end

      it 'creates a new sound' do
        expect {
          post :create, name: 'Dong', format: :json
        }.to change(Sound, :count).by 1
      end

      context 'but the request is invalid' do
        before do
          expect_any_instance_of(Sound).to receive(:valid?).and_return(false)
        end

        it 'returns http unprocessable entity' do
          post :create, format: :json
          expect(response.code).to eq('422')
        end

        it 'renders an error message' do
          post :create, format: :json
          expect(response.body).to include('errors')
        end
      end
    end

  end

  describe "PUT 'update'" do

    context 'when not authenticated' do
      it 'returns http unauthorized' do
        put :update, id: 1, format: :json
        expect(response.code).to eq('401')
      end
    end

    context 'when authenticated' do
      fixtures :sounds

      before do
        allow(controller).to receive(:doorkeeper_token) { token }
        @id = sounds(:ding).id
      end

      it 'returns http success' do
        put :update, id: @id, name: 'Dong', format: :json
        expect(response).to be_success
        expect(response.code).to eq('200')
      end

      it 'assigns a "sound updated successfully" message to @message' do
        put :update, id: @id, name: 'Dong', format: :json
        expect(assigns(:message)).to eq(I18n.t(:successful, scope: [ :sounds, :update ]))
      end

      it 'renders the show template' do
        put :update, id: @id, name: 'Dong', format: :json
        expect(response).to render_template('show')
      end

      it 'updates the requested sound' do
        @sound = sounds(:ding)
        put :update, id: @sound.id, name: 'Dong', format: :json
        @sound.reload
        expect(@sound.name).to eq('Dong')
      end

      context 'but the requested sound is not found' do
        it 'returns http not found' do
          put :update, id: 0, format: :json
          expect(response.code).to eq('404')
        end

        it 'renders an error message' do
          put :update, id: 0, format: :json
          expect(response.body).to eq({
            errors: [
              I18n.t(:not_found, scope: [ :sounds ])
            ]
          }.to_json)
        end
      end

      context 'but the request is invalid' do
        before do
          expect_any_instance_of(Sound).to receive(:valid?).and_return(false)
        end

        it 'returns http unprocessable entity' do
          put :update, id: @id, format: :json
          expect(response.code).to eq('422')
        end

        it 'renders an error message' do
          put :update, id: @id, format: :json
          expect(response.body).to include('errors')
        end
      end
    end

  end

  describe "DELETE 'destroy'" do
    fixtures :sounds

    before do
      @id = sounds(:ding).id
    end

    context 'when not authenticated' do
      it 'returns http unauthorized' do
        delete :destroy, id: @id, format: :json
        expect(response.code).to eq('401')
      end
    end

    context 'when authenticated' do
      before do
        allow(controller).to receive(:doorkeeper_token) { token }
      end

      it "returns http no content" do
        delete :destroy, id: @id, format: :json
        expect(response.code).to eq('204')
      end

      it 'renders nothing' do
        delete :destroy, id: @id, format: :json
        expect(response.body).to be_blank
      end

      it "assigns the requested sound to @sound" do
        delete :destroy, id: @id, format: :json
        expect(assigns(:sound)).to eq(sounds(:ding))
      end

      it 'deletes the requested sound' do
        expect {
          delete :destroy, id: @id, format: :json
        }.to change(Sound, :count).by -1
      end

      context 'but the requested sound is not found' do
        it 'returns http not found' do
          delete :destroy, id: 0, format: :json
          expect(response.code).to eq('404')
        end

        it 'renders an error message' do
          delete :destroy, id: 0, format: :json
          expect(response.body).to eq({
            errors: [
              I18n.t(:not_found, scope: [ :sounds ])
            ]
          }.to_json)
        end
      end
    end

  end

end
