module SwansonApi
  class Search
    def initialize
    end

    def search(query:)
      response = Faraday.get "#{root_url}/search/#{query}"

      if response.status == 200
        JSON.parse(response.body)
      else
        raise Error.new(
          status: response.status,
          message: response.body
        )
      end
    rescue Faraday::Error => e
      raise Error.new(
        status: 500,
        message: "We were unable to connect to the Swanson Quotes API. Please try again later."
      )
    end

    def root_url
      "http://ron-swanson-quotes.herokuapp.com/v2/quotes"
    end
  end
end
