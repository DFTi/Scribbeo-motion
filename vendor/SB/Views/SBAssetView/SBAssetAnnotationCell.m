//
//  SBAssetAnnotationCell.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/2/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "SBAssetAnnotationCell.h"

@interface SBAssetAnnotationCell ()

@property (nonatomic, strong) UIImage*  selectedImage;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *timecodeLabel;

@end

@implementation SBAssetAnnotationCell

@synthesize selectedImage;
@synthesize imageView;
@synthesize timecodeLabel;

@synthesize categoryColor;
@synthesize frameThumbnail;

@synthesize timecodeFont;
@synthesize timecode;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotationThumbSelect"]];
    }
    return self;
}

- (void)setTimecode:(NSString *)newTimecode
{
    timecode = newTimecode;
    self.timecodeLabel.text = newTimecode;
}

- (void)setFrameThumbnail:(UIImage *)newFrameThumbnail
{
    frameThumbnail = newFrameThumbnail;
    self.imageView.image = newFrameThumbnail;
}

- (void)setNeedsDisplay
{
    self.timecodeLabel.text = self.timecode;
    self.imageView.image = self.frameThumbnail;

}

- (UIImageView*)imageView
{
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-37, 38, 176, 99)];
        imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.backgroundView = imageView;
    }
    
    return imageView;
}

@end
