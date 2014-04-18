require 'spec_helper'

describe CallsController do

  describe 'POST /calls' do

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
        ).to be < 0.01
      end

    end

  end

end
