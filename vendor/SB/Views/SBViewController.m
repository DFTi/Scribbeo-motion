//
//  SBViewController.m
//  Scribbeo2
//
//  Created by keyvan on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SBViewController.h"

@implementation SBViewController

@synthesize assetVC;

#pragma mark - View lifecycle

- (void)viewDidLoad
{

    self.view.backgroundColor = [UIColor redColor];
    
    [self.navigationController pushViewController:self.assetVC animated:YES];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    assetVC = nil;
}

#pragma mark - Getters

- (SBAssetVC*)assetVC
{
    
    if (!assetVC) {
        assetVC = [[SBAssetVC alloc] initWithNibName:@"SBAssetVC" bundle:[NSBundle mainBundle]];
    }
    
    return assetVC;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;//UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
