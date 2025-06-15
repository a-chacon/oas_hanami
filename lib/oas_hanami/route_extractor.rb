# frozen_string_literal: true

module OasHanami
  class RouteExtractor
    class << self
      def host_routes
        @host_routes ||= extract_host_routes
      end

      def clear_cache
        @host_routes = nil
      end

      def clean_route(route)
        route.gsub("(.:format)", "").gsub(/:\w+/) { |match| "{#{match[1..]}}" }
      end

      private

      def extract_host_routes
        routes = Hanami.app.router.inspector.call
        routes = transform_routes(routes)
        filter_routes(routes)
      end

      def transform_routes(routes)
        routes.map do |r|
          next unless r.to.is_a? String

          OasRouteBuilder.build_from_hanami_route(r)
        end.compact
      end

      def filter_routes(routes)
        case OasHanami.config.include_mode
        when :with_tags
          routes.select { |route| route.tags.any? }
        when :explicit
          routes.select { |route| route.tags.any? { |t| t.tag_name == "oas_include" } }
        else
          routes
        end
      end
    end
  end
end
