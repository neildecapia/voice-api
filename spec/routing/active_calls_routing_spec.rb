require 'spec_helper'

describe ActiveCallsController do

  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/active_calls').to route_to(
        controller: 'active_calls',
        action: 'index'
      )
    end

    it 'does not route to #show' do
      expect(get: '/v1/active_calls/1').to not_be_routable
    end

    it 'does not route to #new' do
      expect(get: '/v1/active_calls/new').to not_be_routable
    end

    it 'does not route to #create' do
      expect(post: '/v1/active_calls').to not_be_routable
    end

    it 'does not route to #update' do
      expect(put: '/v1/active_calls/1').to not_be_routable
    end

    it 'does not route to #destroy' do
      expect(delete: '/v1/active_calls/1').to route_to(
        controller: 'active_calls',
        action: 'destroy',
        id: '1'
      )
    end
  end

end
