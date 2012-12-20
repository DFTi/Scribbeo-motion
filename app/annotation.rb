class Annotation
  attr_accessor :note, :timecode, :seconds, :comments, :author, :image, :drawing, :media_asset_id

  def initialize(*h)
    if h.length == 1 && h.first.kind_of?(Hash)
      h.first.each { |k,v| send("#{k}=",v) }
    end
  end

  def to_hash
    hash = {}
    self.instance_variables.each do |var|
      hash[var.to_s.delete("@").to_sym] = self.instance_variable_get(var)
    end
    hash
  end

  def uncomposited?
    image['image']['url'].nil?
  end

  class Cell < UITableViewCell
    module Tags
      IMAGE = 1
      AUTHOR = 2
      TIMECODE = 3
    end

    def setSelected(selected, animated:animated)
      self.layer.borderColor = UIColor.yellowColor.CGColor
      self.layer.borderWidth = (selected ? 2 : 0).to_f
    end

    def note=(note)
      Crittercism.leaveBreadcrumb("Annotation::Cell loading with a note")
      image_url = "#{$source.base_uri}/#{note.image['image']['url']}"
      viewWithTag(Tags::IMAGE).setImageWithURL(NSURL.URLWithString(image_url), placeholderImage:UIImage.new)
      viewWithTag(Tags::AUTHOR).setText(note.author['name'])
      viewWithTag(Tags::TIMECODE).setText(note.timecode)
      Crittercism.leaveBreadcrumb("Annotation::Cell returning from note loading")
    end
  end
end