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

  # def drawing=()
  #   @drawing = 
  # end

  def cell_for(tableView, reuseIdentifier, index_path)
    cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:reuseIdentifier)
    end
    image_url = "#{$source.base_uri}/#{image['image']['url']}"
    cell.viewWithTag(1).setImageWithURL(NSURL.URLWithString(image_url), placeholderImage:UIImage.new)
    cell.viewWithTag(2).setText(author['name'])
    cell.viewWithTag(3).setText(timecode)
    cell
  end

end