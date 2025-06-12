# spec/requests/books/show_spec.rb

RSpec.describe "GET /books/:id", type: %i[request db] do
  let(:books) { Hanami.app["relations.books"] }

  context "when a book matches the given ID" do
    let!(:book_id) do
      books.insert(title: "Test Driven Development", author: "Kent Beck")
    end

    it "renders the book" do
      get "/books/#{book_id}"

      expect(last_response).to be_successful
      expect(last_response.content_type).to eq("application/json; charset=utf-8")

      response_body = JSON.parse(last_response.body)

      expect(response_body).to eq(
        "id" => book_id, "title" => "Test Driven Development", "author" => "Kent Beck"
      )
    end
  end

  context "when no book matches the given ID" do
    it "returns not found" do
      get "/books/#{books.max(:id).to_i + 1}"

      expect(last_response).to be_not_found
      expect(last_response.content_type).to eq("application/json; charset=utf-8")

      response_body = JSON.parse(last_response.body)

      expect(response_body).to eq(
        "error" => "not_found"
      )
    end
  end
end
