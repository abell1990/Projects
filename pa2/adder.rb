class Adder
  def initialize(value)
    @value = value
  end

  def method_missing(symbol, *args)
    methodName = symbol.id2name
    if methodName =~ /^plus(\d+)$/
      method_definition = "def " + methodName + "() return @value + " + $1 + " end"
      self.class.class_eval(method_definition)
      eval methodName
    else
      super.method_missing(symbol, *args)
    end
  end
end