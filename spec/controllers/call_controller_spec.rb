require 'spec_helper'

describe CallsController do

  describe 'POST /calls' do

    context 'when not authenticated' do
      it 'responds with an HTTP 401 status code' do
        post :create, format: :json
        expect(response.status).to eq(401)
      end
    end

    context 'when authenticated' do
      let(:token) do
        double accessible?: true
      end

      before do
        allow(controller).to receive(:doorkeeper_token) { token }
      end

      it 'responds successfully with an HTTP 200 status code' do
        post :create, format: :json
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'renders the show template' do
        post :create, format: :json
        expect(response).to render_template('show')
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
