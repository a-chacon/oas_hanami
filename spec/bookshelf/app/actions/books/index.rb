# frozen_string_literal: true

module Bookshelf
  module Actions
    module Books
      class Index < Bookshelf::Action
        include Deps["repos.book_repo"]

        params do
          optional(:page).value(:integer, gt?: 0)
          optional(:per_page).value(:integer, gt?: 0, lteq?: 100)
        end

        # @summary List all books with pagination
        # You should use it for list all the books in database. **Markdown too!**
        #   - A list
        #   - Of Different
        #   - Elements
        # @parameter page(query) [Integer] The page number (default: 1)
        # @parameter per_page(query) [Integer] The number of items per page (default: 5, max: 100)
        # @response Books List of books (200) [Array<Hash{id: String}>]
        # @response_example Books list(200)
        #   [JSON{
        #       "id": 1,
        #       "title": "Example Book",
        #       "author": "John Doe"
        #   }]
        # @tags Books
        def handle(request, response)
          halt 422 unless request.params.valid?

          books = book_repo.all_by_title(
            page: request.params[:page] || 1,
            per_page: request.params[:per_page] || 5
          )

          response.format = :json
          response.body = books.map(&:to_h).to_json
        end
      end
    end
  end
end
