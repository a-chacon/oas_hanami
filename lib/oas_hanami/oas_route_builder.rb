# frozen_string_literal: true

module OasHanami
  class OasRouteBuilder
    def self.build_from_hanami_route(hanami_route)
      new(hanami_route).build
    end

    def initialize(hanami_route)
      @hanami_route = hanami_route
    end

    def build
      OasCore::OasRoute.new(
        controller: controller,
        method_name: method,
        verb: verb,
        path: path,
        docstring: docstring,
        source_string: source_string,
        tags: tags
      )
    end

    private

    def controller_class
      if @hanami_route.to.is_a?(String)
        namespace = Hanami.app.name.gsub("App", "Actions")
        parts = @hanami_route.to.split(".")
        full_class_name = "#{namespace}::#{parts.map(&:camelize).join("::")}"

        full_class_name.split("::").reduce(Object) { |mod, name| mod.const_get(name) }
      else
        @hanami_route.to
      end
    end

    def controller
      controller_class.to_s
    end

    def method
      "handle"
    end

    def verb
      @hanami_route.http_method.downcase
    end

    def path
      @hanami_route.path
    end

    def source_string
      controller_class.instance_method(method).source
    rescue NameError
      "Source not available"
    end

    def docstring
      comment_lines = controller_class.instance_method(method).comment.lines
      processed_lines = comment_lines.map { |line| line.sub(/^# /, "") }

      filtered_lines = processed_lines.reject do |line|
        line.include?("rubocop") ||
          line.include?("TODO")
      end

      ::YARD::Docstring.parser.parse(filtered_lines.join).to_docstring
    rescue NameError
      "Docstring not available"
    end

    def tags
      method_comment = controller_class.instance_method(method).comment

      parse_tags(method_comment)
    rescue NameError
      []
    end

    def parse_tags(comment)
      return [] unless comment

      lines = comment.lines.map { |line| line.sub(/^# /, "") }
      ::YARD::Docstring.parser.parse(lines.join).tags
    end
  end
end
