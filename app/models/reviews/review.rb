class Review < Hashable
  attr_accessor :image_url, :stream_url, :remarks, :approve, :id

  def status
    case approve
    when true ; 'Approved'
    when false; 'Unapproved'
    else ; 'Pending' ; end
  end

end