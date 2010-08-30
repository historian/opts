class Opts::Builder

  attr_accessor :app
  
  def initialize(app=nil, &block)
    @app = app
    @ops = []
    
    if block and block.arity == -1
      instance_eval(&block)
    elsif block_given?
      yield(self)
    end
  end
  
  def use(klass, *args, &block)
    @ops << [klass, args, block]
  end
  
  def run(app)
    @app = app
  end
  
  def to_app
    @target ||= begin
      @ops.reverse.inject(@app) do |app, (klass, args, block)|
        if Class === klass
          klass.new(app, *args, &block)
        else
          klass.app = app
          klass
        end
      end
    end
  end
  
  def call(env, args)
    to_app.call(env, args)
  end
  
end