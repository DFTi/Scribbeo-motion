class DrawView < UIView
  attr_accessor :brush_size, :brush_color, :needs_to_redraw, :has_input,
                :buffer_image, :mid1, :mid2, :cache_brush_size, :previous_point1,
                :previous_point2, :paths, :path_colors, :current_point

  def init
    super
    @brush_size = 5.0
    @brush_color = UIColor.redColor
    @needs_to_redraw = false
    @has_input = false
    @paths ||= []
    @path_colors ||= []
    @buffer_image = UIImage.new
    @cache_brush_size = @brush_size
    self
  end

  # Touches

  def touchesBegan(touches, withEvent:event)
    $media_player.pause
    touch = touches.anyObject
    @previous_point1 = touch.previousLocationInView(self)
    @previous_point2 = touch.previousLocationInView(self)
    @current_point = touch.locationInView(self)
    @has_input = true
  end

  def touchesMoved(touches, withEvent:event)
    touch = touches.anyObject
    previous = touch.previousLocationInView(self)
    current = touch.locationInView(self)

    # check for a minimal distance to avoid silly data
    dist = (sqr(current.x - @previous_point2.x) + sqr(current.y - @previous_point2.y))
    if dist > 1
      @cache_brush_size = (((1 - (dist / sqr(300))) * @brush_size) + @cache_brush_size) / 2
      @previous_point2 = @previous_point1
      @previous_point1 = previous
      @current_point = current

      # calculate mid point
      @mid1 = pointBetween(@previous_point1, andPoint:@previous_point2)
      @mid2 = pointBetween(@current_point, andPoint:@previous_point1)

      @needs_to_redraw = true
      setNeedsDisplay
    end
  end

  # Display

  def drawRect(rect)
    # Avoid overdraw
    if needs_to_redraw
      # Render to buffer
      UIGraphicsBeginImageContext(frame.size)
      @buffer_image.drawInRect(CGRectMake(0, 0, frame.size.width, frame.size.height)) 
      @buffer_image = UIImage.new
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
         
      # CoreGraphics version
         
      # CGContextRef context = UIGraphicsGetCurrentContext();
      
      # CGContextMoveToPoint(context, self.mid1.x, self.mid1.y);
      # # Use QuadCurve is the key
      # CGContextAddQuadCurveToPoint(context, self.previousPoint1.x, self.previousPoint1.y, self.mid2.x, self.mid2.y); 
        
      # CGContextSetLineCap(context, kCGLineCapRound);
      # CGContextSetLineWidth(context, brushSize);
      # CGContextSetStrokeColorWithColor(context, [brushColor CGColor]);
      # CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
      # CGContextStrokePath(context);
        
      @buffer_image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      @needs_to_redraw = false
    end
    @buffer_image.drawInRect(CGRectMake(0, 0, frame.size.width, frame.size.height))
  end

  def svg_representation
    #
  end

  def load_svg_representation
    #
  end

  def clear_drawing
    @paths = []
    @path_colors = []
    @buffer_image = UIImage.new
    @has_input = false
    setNeedsDisplay
  end

  private
  def pointBetween(point1, andPoint:point2)
    x = (point1.x + point2.x) * 0.5
    y = (point1.y + point2.y) * 0.5
    return CGPointMake(x, y)
  end
  def sqr(x); return x * x ;end
end