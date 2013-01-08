//
//  SBNavigationController.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 12/7/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "SBNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SBNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {

        UIImage *navigationBarBG = [UIImage imageNamed:@"navigationBarBG"];
        [self.navigationBar setBackgroundImage:navigationBarBG forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationBar setTintColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
        
        NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionary];
        
        [titleTextAttributes setObject:[UIFont fontWithName:@"Helvetica-Bold" size:20] forKey:UITextAttributeFont];
        [titleTextAttributes setObject:[UIColor colorWithWhite:0.2 alpha:1] forKey:UITextAttributeTextColor];
        [titleTextAttributes setObject:[NSValue valueWithUIOffset:UIOffsetMake(0, 1)] forKey:UITextAttributeTextShadowOffset];
        [titleTextAttributes setObject:[UIColor colorWithWhite:1 alpha:0.2] forKey:UITextAttributeTextShadowColor];
        
        [self.navigationBar setTitleTextAttributes:titleTextAttributes];
        
        self.view.layer.cornerRadius = 3;
        self.view.clipsToBounds = YES;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Presentation

- (UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    UIViewController* retController;
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: 1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        retController = [super popViewControllerAnimated:animated];
        [UIView commitAnimations];
    }
    else {
        retController = [super popViewControllerAnimated:animated];
    }
    
    return retController;
}

@end
