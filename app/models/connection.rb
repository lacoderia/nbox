class Connection

  def self.post url, params

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(params)
    response = http.request(request)   

    return response

  end

  def self.post_with_headers url, params, headers

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(params)
    Connection.set_headers request, headers
    response = http.request(request)   

    return response

  end 

  def self.set_headers request, headers #{access_token, uid, client, expiry, token_type}
    
    request.add_field "access-token", headers["access-token"]
    request.add_field "uid", headers["uid"]
    request.add_field "client", headers["client"]
    request.add_field "expriy", headers["expriy"]
    request.add_field "token-type", headers["token-type"]

    return request

  end

  def self.get_headers response
    {"access-token" => response.header["access-token"], "uid" => response.header["uid"], "client" => response.header["client"], "expiry" => response.header["expiry"], "token-type" => response.header["token-type"]}
  end

end
