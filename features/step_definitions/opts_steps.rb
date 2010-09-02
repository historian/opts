$:.unshift(File.expand_path('../../../lib', __FILE__))
require 'shellwords'
require 'opts'

Given /^the (\w+) application$/ do |name|
  @app = appliction_by_name(name)
end

Given /^a (\w+) table:$/ do |name, table|
  @tables ||= {}
  @tables[name] = table.hashes
end

When /^executed with (\w+) in the (\w+) table$/ do |var, table|
  table    = @tables[table]
  @results = []

  table.each do |env|
    args = env[var]
    real_env = {}

    @app.call(real_env, Shellwords.shellsplit(args))

    env = env.dup
    env.delete(var)
    @results << [args, env, real_env]
  end
end

Then /^the environment must match (\w+) in the (\w+) table$/ do |var, table|
  @results.each do |(args, env, result)|
    unless eval(env[var]) == result[var]
      raise "expected #{env[var].inspect} but got #{result[var].inspect}"
    end
  end
end

def appliction_by_name(name)
  case name
  when 'simple'

    Opts::Builder.new do
      use Opts::OptionParser do
        opt 'count',   :type => :numeric, :short => 'c'
        opt 'verbose', :type => :boolean, :short => 'v'
      end
      run lambda { |env, args| [env, args] }
    end

  end
end
