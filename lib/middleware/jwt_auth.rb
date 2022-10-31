require './lib/json_web_token'

class JwtAuth
  def initialize app
    @app = app
  end

  def call env
    bearer = env['HTTP_AUTHORIZATION']
    jwt = bearer.split.last if bearer
    begin
    @decoded = JsonWebToken.decode(jwt)
    @current_user = User.find_by(email: @decoded['email'])
    rescue ActiveRecord::RecordNotFound => e
      return [401, { 'Content-Type' => 'application/json' }, [e.message]]
    rescue JWT::DecodeError => e
      return [401, { 'Content-Type' => 'application/json' }, [e.message]]
    end
    env[:current_user] = @current_user
    @app.call env
  end
end