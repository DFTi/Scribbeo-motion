class Comments
  attr_accessor :items

  def initialize(comments_ary)
    @items = []
    comments_ary.each do |c|
      @items << Comment.new(c)
    end
  end

  def any?
    @items.any?
  end

  def <<(comment)
    @items << comment
  end

  # Act as tableview dataSource
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "COMMENT_CELL_IDENTIFIER"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      CommentCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    cell.comment = items[indexPath.row]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    items.count
  end
end