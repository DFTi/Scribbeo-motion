module ViewController
  class Base < UIViewController
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
