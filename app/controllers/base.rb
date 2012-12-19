module ViewController
  class Base < UIViewController
    extend IB
    
    def textFieldShouldReturn(textfield)
      textfield.resignFirstResponder
    end
  end
  class Landscape < Base
    def shouldAutorotateToInterfaceOrientation(o)
      (o == UIInterfaceOrientationLandscapeRight) || (o == UIInterfaceOrientationLandscapeLeft)
    end

    def supportedInterfaceOrientations
      UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft
    end

    def shouldAutorotate
      true
    end
  end
end
