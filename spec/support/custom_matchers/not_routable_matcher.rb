require 'rspec/rails/matchers/routing_matchers'

module RSpec::Rails::Matchers::RoutingMatchers

  class NotBeRoutableMatcher < RouteToMatcher

    def matches?(verb_to_path_map)
      @actual = @verb_to_path_map = verb_to_path_map
      # assert_recognizes does not consider ActionController::RoutingError an
      # assertion failure, so we have to capture that and Assertion here.
      match_unless_raises ActiveSupport::TestCase::Assertion, ActionController::RoutingError do
        path, query = *verb_to_path_map.values.first.split('?')
        @scope.assert_recognizes(
          @expected.merge(path: path[1..-1]),
          {method: verb_to_path_map.keys.first, path: path},
          Rack::Utils::parse_query(query)
        )
      end
    end

  end

  def not_be_routable(*expected)
    NotBeRoutableMatcher.new(self, {
      controller: 'application',
      action: 'render_404'
    })
  end

end
