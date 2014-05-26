require 'spec_helper'

describe CallsController do

  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/calls').to route_to(
        controller: 'calls',
        action: 'index'
      )
    end

    it 'does not route to #show' do
      expect(get: '/v1/calls/1').not_to be_routable
    end

    it 'does not route to #new' do
      expect(get: '/v1/calls/new').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/v1/calls').to route_to(
        controller: 'calls',
        action: 'create'
      )
    end

    it 'does not route to #update' do
      expect(put: '/v1/calls/1').not_to be_routable
    end

    it 'does not route to #destroy' do
      expect(delete: '/v1/calls/1').not_to be_routable
    end
  end

end
