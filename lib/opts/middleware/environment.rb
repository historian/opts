class Opts::Environment

  def initialize(app, prefix=nil)
    @app    = app
    @prefix = prefix
  end

  def call(env, args)
    _env = ENV.to_hash

    _env.each do |key, value|
      if @prefix and key.index(@prefix) == 0
        env[key.sub(@prefix, '')] ||= value
      elsif !@prefix
        env[key] ||= value
      end
    end

    @app.call(env, args)
  end

end