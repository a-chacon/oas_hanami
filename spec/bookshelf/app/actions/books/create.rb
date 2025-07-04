# frozen_string_literal: true

module Bookshelf
  module Actions
    module Books
      class Create < Bookshelf::Action
        include Deps["repos.book_repo"]

        params do
          required(:book).hash do
            required(:title).filled(:string)
            required(:author).filled(:string)
          end
        end

        # @summary Create a new book
        # @request_body The book to be created [Reference:#/schemas/Book]
        # @request_body_example Simple Book
        #   [JSON{
        #     "book": {
        #       "title": "Example Book",
        #       "author": "John Doe"
        #     }
        #   }]
        # @response Book created(201) [Hash{ id: String}]
        # @response_example Book created(201)
        #   [JSON{
        #     "id": 1,
        #     "title": "Example Book",
        #     "author": "John Doe"
        #   }]
        # @response Validation errors(422) [Hash{success: Boolean, errors: Array<Hash>}]
        # @tags Books
        def handle(request, response)
          if request.params.valid?
            book = book_repo.create(request.params[:book])

            response.status = 201
            response.body = book.to_json
          else
            response.status = 422
            response.format = :json
            response.body = request.params.errors.to_json
          end
        end
      end
    end
  end
end
