//
//  SBAssetPlayerTimecodeV.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 12/7/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "SBAssetPlayerTimecodeV.h"
#import "UIImage_AutoResizing.h"

@interface SBAssetPlayerTimecodeV ()

@property (nonatomic, strong) UIImage *timecodeLCD;
@property (nonatomic, strong) UIFont *timecodeFont;

@end

@implementation SBAssetPlayerTimecodeV

@synthesize timecode;

@synthesize timecodeLCD;
@synthesize timecodeFont;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    [self.timecodeLCD drawInRect:(CGRect){CGPointMake(0, 0), self.frame.size}];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsFontSmoothing(context, NO);
    
    CGContextSelectFont (context, "SF Electrotome Condensed", 24,kCGEncodingMacRoman);
    CGContextSetTextDrawingMode (context, kCGTextFill);
    
    CGContextSetRGBFillColor (context, 0.6, 0.6, 0.6, 1); 
    CGContextScaleCTM(context, 1.f, -1.f);

    CGContextShowTextAtPoint(context, 39, -20, [timecode UTF8String], [timecode length]);
    
    CGContextSelectFont (context, "SF Electrotome Condensed", 12,kCGEncodingMacRoman);
    CGContextSetRGBFillColor (context, 0.3, 0.3, 0.3, 1); 

    CGContextShowTextAtPoint(context, 47, -30, "HR", 2);
    CGContextShowTextAtPoint(context, 72, -30, "MIN", 3);
    CGContextShowTextAtPoint(context, 99, -30, "SEC", 3);
    CGContextShowTextAtPoint(context, 125, -30, "FR", 2);



    
  //  [self.timecode drawAtPoint:CGPointMake(35 , 5) withFont:self.timecodeFont];
    CGContextSetAllowsFontSmoothing(context, YES);
}

#pragma mark - Setters

- (void)setTimecode:(NSString *)newTimecode
{
    
    timecode = newTimecode;
    
    [self setNeedsDisplay];
    
}

- (void)setFrame:(CGRect)frame
{
    
    CGRect newFrame = frame;
    newFrame.origin.y += 3.f;
    
    [super setFrame:newFrame];
}

#pragma mark - Getters

- (UIImage*)timecodeLCD
{
    
    if (!timecodeLCD) {
        timecodeLCD  = [UIImage autoResizingImageNamed:@"timecodeLCD"];
    }
    
    return timecodeLCD;
    
}

- (UIFont*)timecodeFont
{
    
    if (!timecodeFont) {
        timecodeFont = [UIFont fontWithName:@"SF Electrotome Condensed" size:26.f];
    }
    
    return timecodeFont;
    
}

@end
