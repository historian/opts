module Opts::DSL
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  def call(env, args)
    (env[:stack] ||= []).push self
    self.class.parser.call(env, args)
  ensure
    env[:stack].pop
  end
  
  module ClassMethods
    
    def parser
      @parser ||= begin
        @class_builder   ||= Opts::Builder.new
        @class_opts      ||= Opts::OptionParser.new
        @command_parser  ||= Opts::CommandParser.new
        
        @class_builder.use @class_opts
        @class_builder.run @command_parser
        
        @class_builder.to_app
      end
    end
    
    def class_use(klass, *args, &block)
      @class_builder ||= Opts::Builder.new
      @class_builder.use(klass, *args, &block)
    end
    
    def class_opt(name, options={})
      @class_opts ||= Opts::OptionParser.new
      @class_opts.opt(name, options)
    end
    
    def use(klass, *args, &block)
      @command_builder ||= Opts::Builder.new
      @command_builder.use(klass, *args, &block)
    end
    
    def opt(name, options={})
      @command_opts ||= Opts::OptionParser.new
      @command_opts.opt(name, options)
    end
    
    def arg(name, options={})
      @command_args ||= Opts::ArgumentParser.new
      @command_args.arg(name, options)
    end
    
    def method_added(m)
      @command_parser  ||= Opts::CommandParser.new
      @command_builder ||= Opts::Builder.new
      @command_opts    ||= Opts::OptionParser.new
      @command_args    ||= Opts::ArgumentParser.new
      
      @command_builder.use @command_opts
      @command_builder.use @command_args
      @command_builder.run lambda { |env, args|
        env[:stack].last.__send__(m, env, args)
      }
      @command_parser.cmd(m, @command_builder.to_app)
      
      @command_builder = nil
      @command_opts    = nil
      @command_args    = nil
    end
    
  end
  
end