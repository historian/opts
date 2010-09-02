module Opts::Validations

  def validate_numeric(value)
    case value
    when nil
      nil
    when /^[+-]?[0-9]+[.][0-9]+$/
      value.to_f
    when /^[+-]?[0-9]+$/
      value.to_i
    else
      yield(value)
    end
  end

  def validate_boolean(value)
    case value
    when nil
      nil
    when /^t(rue)?|y(es)?|on$/i
      true
    when /^f(alse)?|n(o)?|off$/i
      false
    else
      yield(value)
    end
  end

  def validate_presence(value, default=nil)
    case value
    when nil
      default or yield(value)
    else
      value
    end
  end

end