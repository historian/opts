class Opts::Environment

  def initialize(app, prefix=nil)
    @app    = app
    @prefix = prefix
  end

  def call(env, args)
    other_env = ENV.to_hash

    if @prefix
      other_env = other_env.inject({}) do |memo, (key, value)|
        if key.index(@prefix) == 0
          memo[key.sub(@prefix, '')] = value
        end
        memo
      end
    end

    env = other_env.merge(env)

    @app.call(env, args)
  end

end