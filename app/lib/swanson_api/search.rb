module SwansonApi
  class Search
    def initialize
    end

    def search(query:)
      response = Faraday.get "#{root_url}/search/#{query}"

      if response.status == 200
        JSON.parse(response.body)
      end
    end

    def root_url
      "http://ron-swanson-quotes.herokuapp.com/v2/quotes"
    end
  end
end
