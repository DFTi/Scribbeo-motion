class Comment < Hashable
  attr_accessor :id, :name, :body, :when, :replies, :gravatar
  
  # Extras to be removed these from the API entity if not needed:
  attr_accessor :user_id, :annotation_id, :created_at, :parent_id, :updated_at

  def initialize(*args)
    super(*args)
    # what is the value of replies, it should be an array,not nil
    @replies = Comments.new(@replies)
  end
end