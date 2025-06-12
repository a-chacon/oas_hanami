RSpec.describe "POST /books", type: %i[request db] do
  let(:request_headers) do
    { "HTTP_ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }
  end

  context "given valid params" do
    let(:params) do
      { book: { title: "Practical Object-Oriented Design in Ruby", author: "Sandi Metz" } }
    end

    it "creates a book" do
      post "/books", params.to_json, request_headers

      expect(last_response).to be_created
    end
  end

  context "given invalid params" do
    let(:params) do
      { book: { title: nil } }
    end

    it "returns 422 unprocessable" do
      post "/books", params.to_json, request_headers

      expect(last_response).to be_unprocessable
    end
  end
end
