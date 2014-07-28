require 'spec_helper'

describe SoundsController do

  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/sounds').to route_to(
        controller: 'sounds',
        action: 'index'
      )
    end

    it 'does not route to #show' do
      expect(get: '/v1/sounds/1').to not_be_routable
    end

    it 'does not route to #new' do
      expect(get: '/v1/sounds/new').to not_be_routable
    end

    it 'routes to #create' do
      expect(post: '/v1/sounds').to route_to(
        controller: 'sounds',
        action: 'create'
      )
    end

    it 'does not route to #edit' do
      expect(get: '/v1/sounds/1/edit').to not_be_routable
    end

    it 'routes to #update' do
      expect(put: '/v1/sounds/1').to route_to(
        controller: 'sounds',
        action: 'update',
        id: '1'
      )
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/sounds/1').to route_to(
        controller: 'sounds',
        action: 'destroy',
        id: '1'
      )
    end
  end

end
