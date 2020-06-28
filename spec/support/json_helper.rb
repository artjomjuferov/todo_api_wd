# Method for testing requests
module Requests
  module JsonBodyMethod
    def json
      JSON.parse(response.body)
    end
  end
end
