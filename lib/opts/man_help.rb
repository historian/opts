class Opts::ManHelp

  def initialize(app, options={})
    @app     = app
    @options = options
  end

  def call(env, args)
    _help, env['man.help'] = env['man.help'], self
    @app.call(env, args)
  ensure
    env['man.help'] = _help
  end

  def exec(env, args)
    Kernel.exec "man #{find_man_page(env, args).inspect}"
  end

  def show(env, args)
    Kernel.system "man #{find_man_page(env, args).inspect}"
  end

private

  def find_man_page(env, args)
    cmds = args.dup
    path = nil

    until cmds.empty?
      path = File.expand_path(cmds.join('-') + '.1', @options[:path])
      break if File.file?(path)
      cmds.pop
    end

    if path.nil? and @options[:default]
      path = File.expand_path(@options[:default], @options[:path])
    end

    unless path
      raise Opts::Error, "No man page was found."
    end

    path
  end

end