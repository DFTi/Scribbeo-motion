//
//  SBAssetScrubberViewController.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/18/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "SBAssetPlayerScrubberVC.h"

#import <QuartzCore/QuartzCore.h>

@interface SBAssetPlayerScrubberVC ()

@property (nonatomic, strong) CAShapeLayer *playheadLayer;
@property (nonatomic, strong) CAShapeLayer *trackLayer;

@property (nonatomic, strong) UILabel *startTimeCode;
@property (nonatomic, strong) UILabel *endTimeCode;


@end

@implementation SBAssetPlayerScrubberVC

@synthesize playheadLayer;
@synthesize trackLayer;

@synthesize startTimeCode;
@synthesize endTimeCode;

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 576, 1024, 32)];
    self.view.backgroundColor = [UIColor grayColor];
        
    [self.view.layer addSublayer:self.trackLayer];
    [self.view.layer addSublayer:self.playheadLayer];
    
    [self.view addSubview:self.startTimeCode];
    [self.view addSubview:self.endTimeCode];



}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Getters

- (CAShapeLayer*)playheadLayer
{
    
    if (!playheadLayer)
    {
        
        playheadLayer = [[CAShapeLayer alloc] init];
        
        UIBezierPath *test = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 8, 32)];
        playheadLayer.path = [test CGPath];
        playheadLayer.fillColor = [[UIColor orangeColor] CGColor];
        playheadLayer.frame = CGRectMake(300, 0, 8, 32);
        
    }
    
    return playheadLayer;
    
}

- (CAShapeLayer*)trackLayer
{
    
    if (!trackLayer)
    {
        
        trackLayer = [[CAShapeLayer alloc] init];
        
        UIBezierPath *test = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 800, 4) cornerRadius:2];
        trackLayer.path = [test CGPath];
        trackLayer.fillColor = [[UIColor blackColor] CGColor];
        trackLayer.frame = CGRectMake((1024-800)/2.f, 15.f, 800, 4);
        
    }
    
    return trackLayer;
    
}

- (UILabel*)startTimeCode
{
    
    if (!startTimeCode)
    {
        startTimeCode = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 112, 20)];
        
        startTimeCode.text = @"00:00:00:00";
        startTimeCode.textColor = [UIColor whiteColor];
        startTimeCode.backgroundColor = [UIColor clearColor];
        startTimeCode.textAlignment = UITextAlignmentCenter;
        
    }
    
    return startTimeCode;
}

- (UILabel*)endTimeCode
{
    
    if (!endTimeCode)
    {
        endTimeCode = [[UILabel alloc] initWithFrame:CGRectMake(1024-112, 5, 112, 20)];
        
        endTimeCode.text = @"00:00:00:00";
        endTimeCode.textColor = [UIColor whiteColor];
        endTimeCode.backgroundColor = [UIColor clearColor];
        endTimeCode.textAlignment = UITextAlignmentCenter;
        
    }
    
    return endTimeCode;
}

@end
