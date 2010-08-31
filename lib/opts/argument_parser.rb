class Opts::ArgumentParser

  include Opts::Validations

  attr_accessor :app

  def initialize(app=nil, &block)
    @app = app
    @args = []

    if block and block.arity == -1
      instance_eval(&block)
    elsif block_given?
      yield(self)
    end
  end

  def arg(name, options={})
    options = { :type => :string, :required => true, :min => 1, :max => 1 }.merge(options)
    options[:max] = nil if options.delete(:splat)
    @args << [name, options]
  end

  def call(env, args)
    new_env, new_args = env.dup, args.dup
    parse(new_env, new_args)
    @app.call(new_env, new_args)
  end

private

  def parse(env, args)
    descs = @args.dup
    while pair = descs.shift
      name, desc = *pair
      value = []

      while arg = args.first
        valid = true

        case desc[:type]
        when :boolean
          arg = validate_boolean(arg) { valid = false }

        when :string
          arg = validate_presence(arg) { valid = false }

        when :numeric
          arg = validate_numeric(arg) { valid = false }

        else
          valid = false

        end

        if valid
          value << arg
          args.shift
        else
          break
        end

        if desc[:max] and desc[:max] == value.size
          break
        end
      end

      if value.empty? and desc[:required]
        raise Opts::InvalidArgumentError, "#{name} is a required argument"
      end

      if desc[:min] > value.size and (desc[:required] || value.size > 0)
        raise Opts::InvalidArgumentError, "minimum #{desc[:min]} values are required for #{name}"
      end

      if desc[:max] and desc[:max] < value.size and (desc[:required] || value.size > 0)
        raise Opts::InvalidArgumentError, "maximum #{desc[:max]} values are allowed for #{name}"
      end

      if desc[:max] and desc[:max] == 1 and desc[:max] == 1
        value = value.shift
      end

      env[name] = value if value
    end
  end

end