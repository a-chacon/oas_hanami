module OasHanami
  class RouteExtractor
    HANAMI_DEFAULT_CONTROLLERS = %w[
      hanami/assets
      hanami/health
    ].freeze

    HANAMI_DEFAULT_PATHS = %w[
      /assets/
      /health/
    ].freeze

    class << self
      def host_routes_by_path(path)
        @host_routes ||= extract_host_routes
        @host_routes.select { |r| r.path == path }
      end

      def host_routes
        @host_routes ||= extract_host_routes
      end

      def clear_cache
        @host_routes = nil
      end

      def host_paths
        @host_paths ||= host_routes.map(&:path).uniq.sort
      end

      def clean_route(route)
        route.gsub("(.:format)", "").gsub(/:\w+/) { |match| "{#{match[1..]}}" }
      end

      private

      def extract_host_routes
        debugger
        #
        # routes = inspector.call.lines.map(&:strip).reject(&:empty?)
        #
        # routes = routes.map { |r| Builders::OasRouteBuilder.build_from_hanami_route(r) }
        #
        # routes.select! { |route| route.tags.any? } if OasHanami.config.include_mode == :with_tags
        # if OasHanami.config.include_mode == :explicit
        #   routes.select! do |route|
        #     route.tags.any? do |t|
        #       t.tag_name == "oas_include"
        #     end
        #   end
        # end
        # routes
        []
      end

      def valid_routes
        extract_host_routes.select do |route|
          valid_api_route?(route)
        end
      end

      def resolve_formatter(format)
        case format
        when "human_friendly"
          require "hanami/router/formatter/human_friendly"
          Hanami::Router::Formatter::HumanFriendly.new
        when "csv"
          require "hanami/router/formatter/csv"
          Hanami::Router::Formatter::CSV.new
        else
          raise ArgumentError, "Unsupported format: #{format}"
        end
      end

      def valid_api_route?(route)
        return false unless valid_route_implementation?(route)
        return false if HANAMI_DEFAULT_CONTROLLERS.any? { |default| route.controller.to_s.start_with?(default) }
        return false if HANAMI_DEFAULT_PATHS.any? { |path| route.path.to_s.include?(path) }
        return false unless route.path.to_s.start_with?(OasHanami.config.api_path)
        return false if ignore_custom_actions(route)

        true
      end

      def valid_route_implementation?(route)
        controller_name = route.controller
        action_name = route.action

        return false if controller_name.blank? || action_name.blank?

        controller_class = "#{controller_name}_controller".camelize.safe_constantize

        if controller_class.nil?
          false
        else
          controller_class.instance_methods.include?(action_name.to_sym)
        end
      end

      def ignore_custom_actions(route)
        api_path = "#{OasHanami.config.api_path.sub(%r{\A/}, "")}/".sub(%r{/+$}, "/")
        ignored_actions = OasHanami.config.ignored_actions.flat_map do |custom_route|
          if custom_route.start_with?(api_path)
            [custom_route]
          else
            ["#{api_path}#{custom_route}", custom_route]
          end
        end

        controller_action = "#{route.controller}##{route.action}"
        controller_only = route.controller

        ignored_actions.include?(controller_action) || ignored_actions.include?(controller_only)
      end
    end
  end
end
