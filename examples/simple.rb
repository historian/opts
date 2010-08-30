$:.unshift File.expand_path('../../lib', __FILE__)
require 'opts'

class CLI
  include Opts
  
  def initialize
    cli = self
    @opts = Opts::Builder.new do
      use Opts::Shell
      use Opts::OptionParser do
        opt 'verbose',
            :short => 'v', :type => :boolean
        opt 'path',
            :short => 'p', :type => :string
      end
      use Opts::CommandParser do
        cmd 'pack', Opts::Builder do
          use Opts::ArgumentParser do
            arg 'GEMFILE', :type => :string
            arg 'COUNT',   :type => :numeric, :required => false, :splat => true
            arg 'PATHS',   :type => :string, :splat => true
          end
          run cli.method(:pack)
        end
        cmd 'deploy', cli.method(:deploy)
      end
      run lambda { raise Error }
    end
  end
  
  def call(env, args)
    @opts.call(env, args)
  end
  
  def pack(env, args)
    env[:shell].say [env, args].inspect, :green
  end
  
  def deploy(env, args)
    p [env, args]
  end
  
end

packer = CLI.new
packer.call({}, ['-v', 'pack', 'Gemfile', '1', '2', 'hello'])
packer.call({}, ['--verbose', 'deploy', 'Gemfile'])
packer.call({}, ['--verbose=f', '-p', 'example.g', 'pack', 'Gemfile', 'lib', 'app'])