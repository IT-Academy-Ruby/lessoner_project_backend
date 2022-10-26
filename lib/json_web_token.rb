class JsonWebToken
  def self.encode(payload)
    JWT.encode(payload, ENV['SECRET_KEY'], ENV['ALGORITHM'])
  end

  def self.decode(token)
    JWT.decode(token, ENV['SECRET_KEY'], true, { algorithm: ENV['ALGORITHM'] }).first
  end
end
