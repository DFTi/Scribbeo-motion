//
//  SBHoldGestureRecognizer.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/29/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "SBHoldGestureRecognizer.h"


@interface SBHoldGestureRecognizer ()



@end

@implementation SBHoldGestureRecognizer


@synthesize requiredNumberOfTouches;
@synthesize requiredHoldDelay;

- (id)init
{
    
    requiredNumberOfTouches = 1;
    requiredHoldDelay = 0.5f;
    
}

- (void)reset
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateBegan;
    
    if ([[event allTouches] count] >= requiredNumberOfTouches) {
        
        //   timer = [NSTimer timerWithTimeInterval:requiredHoldDelay target:self selector:@selector() userInfo:nil repeats:NO];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.state = UIGestureRecognizerStateChanged;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.state = UIGestureRecognizerStateEnded;
    if ([[event allTouches] count] <= 0) {
        
        if (1) {
            
        }
        
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.state = UIGestureRecognizerStateCancelled;

    
}


#pragma mark - Helpers

- (void)delayCallback:(id)userInfo
{
    
    self.state = UIGestureRecognizerStatePossible;
    
    
}

@end
