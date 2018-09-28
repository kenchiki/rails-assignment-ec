# frozen_string_literal: true

class QueryInclusion
  def initialize(args)
    @path = args[:path]
    @request = args[:request]
  end

  def translate(path)
    uri = URI::HTTP.build(path: path)
    query_parameters = @request.query_parameters
    uri.query = query_parameters.to_param if query_parameters.present?
    uri.request_uri
  end
end
