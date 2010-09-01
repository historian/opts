class Opts::Shell

  # Most of this is taken from http://github.com/wycats/thor/blob/master/lib/thor/shell/basic.rb

  CLEAR      = "\e[0m"
  BOLD       = "\e[1m"

  BLACK      = "\e[30m"
  RED        = "\e[31m"
  GREEN      = "\e[32m"
  YELLOW     = "\e[33m"
  BLUE       = "\e[34m"
  MAGENTA    = "\e[35m"
  CYAN       = "\e[36m"
  WHITE      = "\e[37m"

  ON_BLACK   = "\e[40m"
  ON_RED     = "\e[41m"
  ON_GREEN   = "\e[42m"
  ON_YELLOW  = "\e[43m"
  ON_BLUE    = "\e[44m"
  ON_MAGENTA = "\e[45m"
  ON_CYAN    = "\e[46m"
  ON_WHITE   = "\e[47m"

  def initialize(app, options={})
    @app     = app
    @options = { :color => true }.merge(options)
    @padding = 0
    @quiet   = false
  end

  def call(env, args)
    env['opts.shell'] = self

    _quiet = @quiet
    @quiet = env['QUITE']

    @app.call(env, args)

  ensure
    @quiet = _quiet
  end

  def with_padding(padding)
    _padding = @padding
    @padding = padding
    yield
  ensure
    @padding = _padding
  end

  def padding
    @padding
  end

  def with_quiet(quiet=true)
    _quiet = @quiet
    @quiet = quiet
    yield
  ensure
    @quiet = _quiet
  end

  def quiet?
    @quiet
  end

  def say(message="", color=nil, force_new_line=(message.to_s !~ /( |\t)$/))
    return if quiet?

    message = message.to_s
    message = set_color(message, color) if color

    spaces = "  " * padding

    if force_new_line
      $stdout.puts(spaces + message)
    else
      $stdout.print(spaces + message)
    end
    $stdout.flush
  end

  def status(type, message, log_status=true)
    return if quiet? || log_status == false
    spaces = "  " * (padding + 1)
    color  = log_status.is_a?(Symbol) ? log_status : :green

    status = status.to_s.rjust(12)
    status = set_color status, color, true if color

    $stdout.puts "#{status}#{spaces}#{message}"
    $stdout.flush
  end

  def set_color(string, color=false, bold=false)
    if color and @options[:color]
      color = self.class.const_get(color.to_s.upcase) if color.is_a?(Symbol)
      bold  = bold ? BOLD : ""
      "#{bold}#{color}#{string}#{CLEAR}"
    else
      string
    end
  end

  def inspect
    "#<#{self.class} #{@options[:color] ? 'COLORED' : 'BW'}>"
  end

end