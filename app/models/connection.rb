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

    return Connection.http_request_with_headers "post", url, params, headers

  end 

  def self.get_with_headers url, headers
    
    return Connection.http_request_with_headers "get", url, nil, headers
  
  end

  def self.put_with_headers url, params, headers
    
    return Connection.http_request_with_headers "put", url, params, headers

  end

  def self.http_request_with_headers request_type, url, params, headers

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    if request_type == "get"
      request = Net::HTTP::Get.new(uri.request_uri)
    elsif request_type == "post"
      request = Net::HTTP::Post.new(uri.request_uri)
    elsif request_type == "put"
      request = Net::HTTP::Put.new(uri.request_uri)
    else
      request = Net::HTTP::Delete.new(uri.request_uri)
    end

    request.set_form_data(params) if params
    
    Connection.set_headers request, headers
    response = http.request(request)   

    return response

  end

  def self.set_headers request, headers #{access_token, uid, client, expiry, token_type}
    
    request.add_field "access-token", eval(headers["access-token"])
    request.add_field "uid", eval(headers["uid"])
    request.add_field "client", eval(headers["client"])
    request.add_field "expriy", eval(headers["expriy"])
    request.add_field "token-type", eval(headers["token-type"])

    return request

  end

  def self.get_headers response
    {"access-token" => response.header["access-token"], "uid" => response.header["uid"], "client" => response.header["client"], "expiry" => response.header["expiry"], "token-type" => response.header["token-type"]}
  end

end
