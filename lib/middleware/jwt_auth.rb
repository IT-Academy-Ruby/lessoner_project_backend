class JwtAuth
  def initialize(app)
    @app = app
  end

  def call(env)
    bearer = env['HTTP_AUTHORIZATION']
    jwt = bearer.split.last if bearer
    begin
      @decoded = JsonWebToken.decode(jwt)
      @current_user = User.find_by!(email: @decoded['email'])
    rescue => e
      return [401, { 'Content-Type' => 'application/json' }, [e.message]]
    end
    env[:current_user] = @current_user
    @app.call(env)
  end
end
