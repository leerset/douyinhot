class And

  def method_missing(a, *args)
    nil
  end

  def [](*k)
    nil
  end

  def <=>(q)
    nil
  end

  def id
    nil
  end

  def dup
    nil
  end

  def to_param
    nil
  end

  def to_s
    nil
  end

  def to_s
    nil
  end

  def inspect
    nil
  end

end

class Object
  def and
    self.nil? ? And.new : self
  end
end

