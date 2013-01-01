class Note < Hashable
  attr_accessor :note, :timecode, :seconds, :discussion, :author, :image, :drawing, :media_asset_id, :when, :comments

  def initialize(*args)
    super(*args)
    if @discussion
      @comments = Comments.new(top_level_comments)
    end
  end

  def top_level_comments
    @discussion.first['replies']
  end

  def self.colorbars
    UIImage.imageNamed('colorbars.jpg')
  end

  def uncomposited?
    image['image']['url'].nil? rescue false
  end

  def has_image?
    !image['image']['url'].nil?
  end

  def has_drawing?
    !drawing['drawing']['url'].nil?
  end

  def image_url
    "#{$source.base_uri}/#{image['image']['url']}".nsurl
  end

  def drawing_url
    "#{$source.base_uri}/#{drawing['drawing']['url']}".nsurl
  end

  def author_name
    @author['name'] rescue 'Unknown'
  end

  def text
    @note
  end
end