module ViewController
  class Base < UIViewController
  end

  class Landscape < Base
    def preferredInterfaceOrientationForPresentation
      UIInterfaceOrientationLandscapeLeft
    end

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