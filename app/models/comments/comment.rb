class Comment < Hashable
  attr_accessor :text, :image_url

  def fetch_replies!(&block)
    # @comments = []
    # url = $source.api('comments')
    # BW::HTTP.get(url, payload: {private_token: $token}) do |res|
    #   if res.ok?
    #     BW::JSON.parse(res.body.to_str).each do |r|
    #       @comments << Comment.new(r)
    #     end
    #     block.call unless block.nil?
    #   end
    # end
    # self
  end
end