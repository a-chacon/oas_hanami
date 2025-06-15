# frozen_string_literal: true

module Bookshelf
  module Actions
    module Home
      class Index < Bookshelf::Action
        # @summary Welcome message for the Bookshelf API
        # @response Welcome message(200) [String] A simple welcome message
        # @no_auth
        # @tags Home
        def handle(_request, response)
          response.body = "Welcome to Bookshelf"
        end
      end
    end
  end
end
