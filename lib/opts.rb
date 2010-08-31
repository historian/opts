module Opts

  Error                = Class.new(RuntimeError)
  UnknownCommandError  = Class.new(Error)
  UnknownOptionError   = Class.new(Error)
  InvalidOptionError   = Class.new(Error)
  InvalidArgumentError = Class.new(Error)

  require 'opts/version'
  require 'opts/validations'
  require 'opts/builder'
  require 'opts/dsl'

  require 'opts/middleware/argument_parser'
  require 'opts/middleware/command_parser'
  require 'opts/middleware/environment'
  require 'opts/middleware/man_help'
  require 'opts/middleware/option_parser'
  require 'opts/middleware/shell'

end
