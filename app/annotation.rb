class Annotation
  attr_accessor :note, :timecode, :seconds, :comments, :author, :image

  def initialize(*h)
    if h.length == 1 && h.first.kind_of?(Hash)
      h.first.each { |k,v| send("#{k}=",v) }
    end
  end

  def to_hash
    hash = {}
    self.instance_variables.each {|var| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
    hash
  end

  class Cell < UITableViewCell
    def setSelected(selected, animated:animated)
      self.layer.borderColor = UIColor.yellowColor.CGColor
      self.layer.borderWidth = (selected ? 2 : 0).to_f
    end
  end
end