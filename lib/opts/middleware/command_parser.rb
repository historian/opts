class Opts::CommandParser
  
  def initialize(default_app=nil, &block)
    @default_app = default_app
    @commands = {}
    
    if block and block.arity == -1
      instance_eval(&block)
    elsif block_given?
      yield(self)
    end
  end
  
  def cmd(name, app=nil, *args, &block)
    if Class === app
      app = app.new(*args, &block)
    end
    @commands[name.to_s] = {
      :app  => app || block
    }
  end
  
  def call(env, args)
    cmd_name = args.first.to_s
    cmd = @commands[cmd_name]
    
    raise Opts::UnknownCommandError, "Unknown command #{cmd_name}" unless cmd
    
    (env['commands'] ||= []) << cmd_name
    cmd[:app].call(env, args[1..-1])
  end
  
end