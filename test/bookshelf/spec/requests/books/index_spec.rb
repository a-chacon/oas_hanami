# frozen_string_literal: true

RSpec.describe "GET /books", type: %i[request db] do
  let(:books) { Hanami.app["relations.books"] }

  before do
    books.insert(title: "Practical Object-Oriented Design in Ruby", author: "Sandi Metz")
    books.insert(title: "Test Driven Development", author: "Kent Beck")
  end

  it "returns a list of books" do
    get "/books"

    expect(last_response).to be_successful
    expect(last_response.content_type).to eq("application/json; charset=utf-8")

    response_body = JSON.parse(last_response.body)

    expect(response_body).to eq [
      { "title" => "Practical Object-Oriented Design in Ruby", "author" => "Sandi Metz" },
      { "title" => "Test Driven Development", "author" => "Kent Beck" }
    ]
  end
end
