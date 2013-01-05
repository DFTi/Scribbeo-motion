class Note < Hashable
  attr_accessor :id, :note, :timecode, :seconds, :discussion, :author, :image, :drawing, :media_asset_id, :when, :comments

  def initialize(*args)
    super(*args)
    initialize_discussion
  end

  def refresh!(&block)
    url = $source.api("annotations/#{id}")
    BW::HTTP.get(url, payload: {private_token: $token, id: id}) do |res|
      if res.ok?
        load BW::JSON.parse(res.body.to_str)
        initialize_discussion
        block.call
      else
        App.alert 'Could not refresh note data.'
      end
    end
    self
  end

  def create_comment!(comment, &block)
    payload = {private_token: $token, comment: comment.to_hash}
    url = $source.api "annotations/#{id}/comment"
    BW::HTTP.put(url, payload: payload) do |res|
      user_feedback = if res.ok?
        {:success => true, :message => "Comment saved on server.", :comment => BW::JSON.parse(res.body.to_str)}
      else
        {:success => false, :message => res.error_message}
      end
      block.call(user_feedback)
    end
    self
  end

  def initialize_discussion
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