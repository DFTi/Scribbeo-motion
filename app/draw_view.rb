class DrawView < UIView
  attr_accessor :brush_size, :brush_color, :needs_to_redraw, :has_input,
                :buffer_image, :mid1, :mid2, :cache_brush_size, :previous_point1,
                :previous_point2, :paths, :path_colors

	def initialize
    @brush_size = 5.0
    @brush_color = UIColor.redColor
    @needs_to_redraw = false
    @has_input = false
  end

  # Touches

  def touchesBegan(touches, withEvent:event)
    touch = touches.anyObject
    @previous_point1 = touch.previousLocationInView(self)
    @previous_point2 = touch.previousLocationInView(self)
    current_point
  end

  def touchesMoved(touches, withEvent:event)

  end

  # Display

  def drawRect(rect)
    # Avoid overdraw
    if needs_to_redraw
      
      # Render to buffer
      UIGraphicsBeginImageContext(frame.size)
      buffer_image.drawInRect(CGRectMake(0, 0, frame.size.width, CGFloat frame.size.height))
      buffer_image = nil
      new_path = UIBezierPath.bezierPath
      new_path.moveToPoint(@mid1)
      new_path.addQuadCurveToPoint(@mid2, controlPoint:@previous_point1)
      new_path.setLineWidth(@cache_brush_size)
      new_path.setLineCapStyle(KCGLineCapRound)
      @brush_color.setStroke
      new_path.stroke
      # Save
      @paths.addObject(new_path)
      @path_colors.addObject(@brush_color)
      @buffer_image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      @needs_to_redraw = false
    end
    buffer_image.drawInRect(CGRectMake(0, 0, frame.size.width, CGFloat frame.size.height))
  end

end