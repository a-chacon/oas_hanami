# frozen_string_literal: true

module Bookshelf
  module Actions
    module Home
      class Index < Bookshelf::Action
        def handle(request, response)
          response.body = "Welcome to Bookshelf"
        end
      end
    end
  end
end
