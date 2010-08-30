class Opts::OptionParser
  
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
    
    while args.first =~ /^(?:--([^-][^=]*)|-([^=-]))(?:=(.+))?$/
      args.shift
      
      long_name, short_name = $1, $2
      name                  = long_name || short_name
      value                 = $3
      long_name           ||= @short_names[short_name]
      option                = @options[long_name]
      
      unless option
        raise Opts::UnknownOptionError, "Unknown option #{name}"
      end
      
      case option[:type]
      when :boolean
        if value
          case value
          when /^t(rue)?|y(es)?|1$/i
            value = true
          when /^f(alse)?|n(o)?|0$/i
            value = false
          else
            raise Opts::InvalidOptionError, "Invalid boolean option --#{long_name}"
          end
        else
          
          value = true
        end
        
      when :string
        if value.nil? or value.empty?
          value = args.shift
        end
        
      when :numeric
        if value.nil? or value.empty?
          value = args.shift
        end
        
        case value
        when /^[+-]?[0-9]+[.][0-9]+$/
          value = value.to_f
        when /^[+-]?[0-9]+$/
          value = value.to_i
        else
          raise Opts::InvalidOptionError, "Invalid numeric option --#{long_name}=#{value}"
        end
        
      end
      
      if NilClass === value and option[:default]
        value = option[:default]
      end
      
      if NilClass === value
        raise Opts::InvalidOptionError, "Invalid option --#{name}"
      end
      
      defined_opts << long_name
      env[long_name] = value
    end
    
    (@options.keys - defined_opts).each do |name|
      option = @options[name]
      
      if option[:default]
        env[name] = option[:default]
      elsif option[:required]
        raise Opts::InvalidOptionError, "#{name} is a required option"
      end
    end
  end
  
end