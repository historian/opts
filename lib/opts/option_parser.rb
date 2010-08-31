class Opts::OptionParser

  include Opts::Validations

  attr_accessor :app

  def initialize(app=nil, &block)
    @options = {}
    @short_names = {}
    @app = app

    if block and block.arity == -1
      instance_eval(&block)
    elsif block_given?
      yield(self)
    end
  end

  def call(env, args)
    new_env, new_args = env.dup, args.dup
    parse(new_env, new_args)
    @app.call(new_env, new_args)
  end


  def opt(name, options={})
    if short = options[:short]
      @short_names[short.to_s] = name.to_s
    end

    @options[name.to_s] = {
      :type => :boolean
    }.merge(options)
  end

private

  def parse(env, args)
    defined_opts = []

    while args.first =~ /^(?:--(no(?:t)-)?([^-][^=]*)|-([^=-]))(?:=(.+))?$/
      args.shift

      long_name, short_name = $2, $3
      negation, value       = $1, $4
      name                  = "--#{long_name}" || "-#{short_name}"
      long_name           ||= @short_names[short_name]
      option                = @options[long_name]

      unless option
        raise Opts::UnknownOptionError, "Unknown option #{name}"
      end

      case option[:type]
      when :boolean
        value = validate_boolean(value) do
          raise Opts::InvalidOptionError, "Invalid boolean option #{name}"
        end

        if value.nil?
          value = option[:default] || true
        end

        value = !value if negation

      when :string

      when :numeric
        value = validate_numeric(value) do
          raise Opts::InvalidOptionError, "Invalid numeric option #{name}=#{value}"
        end

      end

      validate_presence(value, option[:default]) do
        raise Opts::InvalidOptionError, "Invalid option #{name}"
      end

      defined_opts << long_name
      env[long_name.upcase] = value
    end

    (@options.keys - defined_opts).each do |name|
      option = @options[name]

      if option[:default]
        env[name.upcase] = option[:default]
      elsif option[:required]
        raise Opts::InvalidOptionError, "#{name} is a required option"
      end
    end
  end

end