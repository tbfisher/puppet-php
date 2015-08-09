def var_export(val)

    if val.class == String

        val = val.gsub(/'/, '\\\\\0')
        "'#{val}'"

    elsif val.class == Array

        val = val.collect{|v| var_export(v) }.join(', ')
        "array(#{val})"

    elsif val.class == Hash

        val = val.collect{|k,v| var_export(k) + ' => ' + var_export(v) }.join(', ')
        "array(#{val})"

    # checking whether foo is a boolean
    elsif !!val == val

        val ? "TRUE" : "FALSE"

    elsif val.is_a? Numeric

        val.to_s()

    else

        raise(Puppet::ParseError, 'to_php(): Could not convert ' +
            val.to_s())

    end
end

module Puppet::Parser::Functions
  newfunction(:to_php, :type => :rvalue, :doc => <<-EOS
    Converts a value to a PHP literal.
    EOS
  ) do |args|

    raise(Puppet::ParseError, 'to_php(): Wrong number of arguments ' +
      "given (#{args.size} for 1)") if args.size != 1

    var_export(args[0])

  end

end
