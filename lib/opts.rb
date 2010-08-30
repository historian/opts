module Opts

  Error                = Class.new(RuntimeError)
  UnknownCommandError  = Class.new(Error)
  UnknownOptionError   = Class.new(Error)
  InvalidOptionError   = Class.new(Error)
  InvalidArgumentError = Class.new(Error)

  require 'opts/version'
  require 'opts/option_parser'
  require 'opts/argument_parser'
  require 'opts/command_parser'
  require 'opts/builder'
  require 'opts/shell'
  require 'opts/dsl'

end
