require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    Search.create(query: "Bacon", quotes: ["Bacon First", "Bacon Second"])
    Search.create(query: "Burgers", quotes: ["Burger First", "Burger Second"])

    get searches_url
    assert_response :success

    assert_includes @response.body, "Bacon First"
    assert_includes @response.body, "Bacon Second"
    assert_includes @response.body, "Burger First"
    assert_includes @response.body, "Burger Second"
  end

  test "should allow filtering the index by query" do
    Search.create(query: "Bacon", quotes: ["Bacon"])
    Search.create(query: "Burgers", quotes: ["Burger"])
    Search.create(query: "Cheeseburgers", quotes: ["Different Text Here"])

    get searches_url, params: { filter: "burger" }
    assert_response :success

    assert_not_includes @response.body, "Bacon"
    assert_includes @response.body, "Burger"
    assert_includes @response.body, "Different Text Here"
  end

  test "sorts ascending query by default" do
    Search.create(query: "Apple", quotes: [])
    Search.create(query: "Burgers", quotes: [])
    Search.create(query: "Cheeseburgers", quotes: [])

    get searches_url
    assert_response :success

    assert @response.body.index("Cheese") > @response.body.index("Apple")
  end

  test "should allow sorting the index by query" do
    Search.create(query: "Apple", quotes: [])
    Search.create(query: "Burgers", quotes: [])
    Search.create(query: "Cheeseburgers", quotes: [])

    get searches_url, params: { sort: "desc" }
    assert_response :success

    assert @response.body.index("Cheese") < @response.body.index("Apple")
  end

  test "should get search by id" do
    @search = Search.create(query: "Bacon", quotes: ["Bacon First", "Bacon Second"])

    get search_url(@search)
    assert_response :success

    assert_includes @response.body, "Bacon First"
    assert_includes @response.body, "Bacon Second"
  end

  test "should fail gracefully for a nonexistent id" do
    assert_raises ActiveRecord::RecordNotFound do
      get search_url(999_999)
    end
  end

  test "should return an existing search for a particular query" do
    @search = Search.create(query: "Bacon", quotes: ["Bacon First", "Bacon Second"])

    # Ensure our API service is never called in this case
    search_api = Minitest::Mock.new
    def search_api.search(query:); raise StandardError; end

    SwansonApi::Search.stub :new, search_api do
      post searches_url, params: { query: "Bacon" }
      assert_response :success

      assert_includes @response.body, "Bacon First"
      assert_includes @response.body, "Bacon Second"
    end
  end

  test "should create a new search for a nonexistent query" do
    stub_request(:get, SwansonApi::Search.new.root_url + "/search/Bacon")
      .to_return({body: "[\"Bacon First\",\"Bacon Second\"]"})

    assert_equal Search.count, 0

    post searches_url, params: { query: "Bacon" }
    assert_response :success

    assert_equal Search.count, 1
    assert_includes @response.body, "Bacon First"
    assert_includes @response.body, "Bacon Second"
  end
end
