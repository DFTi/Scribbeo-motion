//
//  SBHoldGestureRecognizer.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/29/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>



@interface SBHoldGestureRecognizer : UIGestureRecognizer

- (void)reset;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@property (nonatomic) NSUInteger requiredNumberOfTouches;
@property (nonatomic) NSTimeInterval requiredHoldDelay;

@end
