//
//  SBAppDelegate.m
//  Scribbeo2
//
//  Created by keyvan on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SBAppDelegate.h"

#import "SBAssetNavigatorVC.h"


@implementation SBAppDelegate

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //SBAssetNavigatorVC* rootView = self.navigationController.topViewController.asset save];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    
    
    
}

#pragma mark - Getters

- (UIWindow*)window
{
    if (!window)
    {
        
        window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    }
    
    return window;
}

- (SBNavigationController*)navigationController
{
    
    if (!navigationController)
    {
    
        SBAssetNavigatorVC *assetNavigator = [[SBAssetNavigatorVC alloc] initWithNibName:@"SBAssetNavigatorVC" bundle:[NSBundle mainBundle]];
        
        //NSData* thisAssetData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://10.0.2.1:3333/assets.json"]];
        NSData *thisAssetData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"studioview" ofType:@"json"]];
        
        SBAsset* folderAsset = [SBAsset assetWithJSONData:thisAssetData];
        
        
        NSData* testData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testAsset" ofType:@"json"]];
        
        SBAsset* testAsset = [SBAsset assetWithJSONData:testData];
        testAsset.metadata.url = [[[NSBundle mainBundle] URLForResource:@"testVideo" withExtension:@"mov"] absoluteString];
        
        
        [folderAsset.subAssets addObject:testAsset];

        assetNavigator.asset = folderAsset;

        
        navigationController = [[SBNavigationController alloc] initWithRootViewController:assetNavigator];
        navigationController.navigationBar.barStyle = UIBarStyleBlack;
        
        
    }
    
    
    return navigationController;
}


@end
