class BufferApp::ResponseParser

  ERROR_MESSAGES = {
    "You do not have permission to post to any of the profile_id's provided." => BufferApp::Unauthorized,
    "The provided access token is invalid" => BufferApp::Unauthorized
  }

  ERROR_CODES = {
    1001 => BufferApp::Unauthorized,
    1002 => BufferApp::Unauthorized,
    1003 => BufferApp::BadRequest,
    1004 => BufferApp::BadRequest,
    1005 => BufferApp::BadRequest,
    1010 => BufferApp::NotFound,
    1011 => BufferApp::Unauthorized,
    1020 => BufferApp::NotFound,
    1021 => BufferApp::Unauthorized,
    1022 => BufferApp::BadRequest,
    1023 => BufferApp::BufferLimitReached,
    1024 => BufferApp::BufferLimitReached,
    1030 => BufferApp::BadRequest,
  }

  def self.parse(response)
    if response['success']
      if (error = ERROR_MESSAGES[response['message']])
        raise error, response['message']
      end
    else
      if response.has_key?('code')
        if (error = ERROR_CODES[response['code']])
          raise error, response['message']
        else
          raise BufferApp::APIError, "Unknown error code: #{response['code']}\nMessage: #{response['message']}"
        end
      end
    end

    if response.has_key?('error')
      if (error = ERROR_MESSAGES[response['error']])
        raise error, response['error']
      end
    end

    response
  end

end
