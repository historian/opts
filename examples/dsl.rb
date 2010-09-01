$:.unshift File.expand_path('../../lib', __FILE__)
require 'opts'

class CLI
  include Opts::DSL

  class_use Opts::Shell
  class_use Opts::ErrorHandler
  class_use Opts::Environment, 'OPTS_'
  class_use Opts::ManHelp,
    :path    => "/Library/Ruby/Gems/1.8/gems/passenger-2.2.15/man",
    :default => 'passenger-make-enterprisey.8'

  class_option 'debug',   :short => 'd', :type => :boolean
  class_option 'verbose', :short => 'v', :type => :boolean
  class_option 'path',    :short => 'p', :type => :string

  argument 'GEMFILE', :type => :string
  argument 'COUNT',   :type => :numeric, :splat => true, :required => false
  argument 'PATHS',   :type => :string,  :splat => true
  def pack(env, args)
    env['opts.shell'].say [env, args].inspect, :green
  end

  option 'cluster', :type => :string, :required => true
  def deploy(env, args)
    p [env, args]
  end

  def help(env, args)
    env['man.help'].exec(env, args)
  end

end

CLI.new.call({}, ARGV)
