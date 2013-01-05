class Hashable
  def load(*h)
    if h.length == 1 && h.first.kind_of?(Hash)
      h.first.each { |k,v| send("#{k}=",v) }
    end
  end

  def initialize(*h)
    load(*h)
  end

  def to_hash
    hash = {}
    self.instance_variables.each do |var|
      hash[var.to_s.delete("@").to_sym] = self.instance_variable_get(var)
    end
    hash
  end
end