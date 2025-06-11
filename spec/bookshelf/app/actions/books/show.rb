# frozen_string_literal: true

# app/actions/books/show.rb

module Bookshelf
  module Actions
    module Books
      class Show < Bookshelf::Action
        include Deps["repos.book_repo"]

        params do
          required(:id).value(:integer)
        end

        # @summary Retrieve a book by ID
        # This is a example docstring **Use with carefull**
        # @parameter id(path) [!Integer] The ID of the book to retrieve
        # @response Book found(200) [Hash] The book details
        # @response_example Book found(200) [Hash]
        #   {
        #     id: 1,
        #     title: "Example Book",
        #     author: "John Doe"
        #   }
        # @response Book not found(404) [Hash{success: Boolean, message: String}] Error message
        # @tags Books
        def handle(request, response)
          book = book_repo.get(request.params[:id])

          response.format = :json
          response.body = book.to_h.to_json
        end
      end
    end
  end
end
