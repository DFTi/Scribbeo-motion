class Comments
  attr_reader :comments

  def initialize
    @comments = []
  end

  def << comment
    p 'adding a comment'
    @comments << comment
  end

  def fetch_comments!(&block)
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

  # Act as tableview dataSource
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "COMMENT_CELL_IDENTIFIER"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      CommentCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    cell.comment = comments[indexPath.row]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    comments.count
  end
end