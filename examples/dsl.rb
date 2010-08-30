$:.unshift File.expand_path('../../lib', __FILE__)
require 'opts'

class CLI
  include Opts::DSL
  
  class_use Opts::Shell
  class_opt 'verbose', :short => 'v', :type => :boolean
  class_opt 'path',    :type => :string, :short => 'p'
  
  arg 'GEMFILE', :type => :string
  arg 'COUNT',   :type => :numeric, :required => false, :splat => true
  arg 'PATHS',   :type => :string, :splat => true
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