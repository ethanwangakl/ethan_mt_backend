module JwtHelper
  SECRET_KEY = "This is a very secure secret key"

  # Encode payload to generate a token
  def self.encode(payload)
    puts "SECRET_KEY encode: #{SECRET_KEY}"
    JWT.encode(payload, SECRET_KEY)
  end

  # Decode the token to retrieve the payload
  def self.decode(token)
    puts "SECRET_KEY decode: #{SECRET_KEY}"
    JWT.decode(token, SECRET_KEY).first
  rescue JWT::DecodeError
    nil
  end
end
