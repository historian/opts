class Opts::ErrorHandler

  def initialize(app)
    @app = app
  end

  def call(env, args)
    @app.call(env, args)
  rescue Object => e
    if env['DEBUG'] || env['opts.debug']
      message = "#{e.message} (#{e.class})\n#{e.backtrace.join("\n")}"
    else
      message = e.message
    end
    env['opts.shell'].status 'Error', message, :red
  end

end