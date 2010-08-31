$:.unshift File.expand_path('../../lib', __FILE__)
require 'opts'

class CLI
  include Opts::DSL

  class_use Opts::Shell
  class_use Opts::Environment, 'OPTS_'
  class_use Opts::ManHelp,
    :path    => "/Library/Ruby/Gems/1.8/gems/passenger-2.2.15/man",
    :default => 'passenger-make-enterprisey.8'
  class_opt 'verbose', :short => 'v', :type => :boolean
  class_opt 'path',    :short => 'p', :type => :string

  arg 'GEMFILE', :type => :string
  arg 'COUNT',   :type => :numeric, :splat => true, :required => false
  arg 'PATHS',   :type => :string,  :splat => true
  def pack(env, args)
    env['opts.shell'].say [env, args].inspect, :green
  end

  opt 'cluster', :type => :string, :required => true
  def deploy(env, args)
    p [env, args]
  end

  def help(env, args)
    env['man.help'].exec(env, args)
  end

end

CLI.new.call({}, ARGV)
