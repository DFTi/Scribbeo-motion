class Reviews
  attr_reader :reviews

  def initialize
    @reviews = []
  end

  def all
    @reviews
  end
  
  def fetch_reviews!(&block)
    @reviews = []
    url = $source.api('reviews')
    BW::HTTP.get(url, payload: {private_token: $token}) do |res|
      if res.ok?
        BW::JSON.parse(res.body.to_str).each do |r|
          @reviews << Review.new(r)
        end
        block.call unless block.nil?
      end
    end
    self
  end

  def update_review!(review, &block)
    payload = {private_token: $token, review: review.to_hash}
    url = $source.api "reviews/#{review.id}"
    BW::HTTP.put(url, payload: payload) do |res|
      user_feedback = if res.ok?
        {:success => true, :message => "Review updated on server."}
      else
        msg = "Review action could not be saved.\nError:#{res.error_message}"
        {:success => false, :message => msg }
      end
      block.call(user_feedback)
    end
    self
  end

  # Act as tableview dataSource
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "REVIEW_CELL_IDENTIFIER"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      ReviewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    cell.review = reviews[indexPath.row]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    reviews.count
  end
end