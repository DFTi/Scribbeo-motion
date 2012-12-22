class Note
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
    image['image']['url'].nil? rescue false
  end

  def image_url
    NSURL.URLWithString("#{$source.base_uri}/#{@image['image']['url']}") rescue ''
  end

  def placeholder_image
    UIImage.imageNamed('colorbars.jpg')
  end

  def author_name
    @author['name'] rescue 'Unknown'
  end

  def text
    @note
  end
end