//
//  SBAssetNavigatorVC.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/8/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "SBAssetNavigatorVC.h"

#import "SBAssetView/SBVideoAssetVC.h"
#import "CustomViews/SBAssetNavigatorCell.h"
#import "CustomViews/SBNavigationDetailV.h"

#import "../Tools/UIImage_AutoResizing.h"
#import "../Tools/ZTTVCTemplateLibrary.h"

@interface SBAssetNavigatorVC ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView* frameBottom;
@property (nonatomic, strong) ZTTVCTemplateLibrary* cellTemplateLibrary;

@property (nonatomic, strong) SBVideoAssetVC *videoAssetVC;

@property (strong, nonatomic) IBOutlet SBNavigationDetailV *navigationDetailV;

- (IBAction)enterAnnotationMode:(UIButton*)sender;

@end

@implementation SBAssetNavigatorVC

#pragma mark Private Properties

@synthesize tableView;
@synthesize frameBottom;
@synthesize cellTemplateLibrary;

@synthesize videoAssetVC;
@synthesize navigationDetailV;

#pragma mark Public Properties

@synthesize asset;

#pragma mark - Lifecycle

+ (SBAssetNavigatorVC*)assetNavigatorWithAsset:(SBAsset*)anAsset
{
    SBAssetNavigatorVC *assetNavigator = [[SBAssetNavigatorVC alloc] initWithNibName:@"SBAssetNavigatorVC" bundle:[NSBundle mainBundle]];
    
    if (assetNavigator)
    {
        assetNavigator.asset = anAsset;
    }
        
    return assetNavigator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.frameBottom.image = [UIImage autoResizingImageNamed:@"toolbarDepthBG"];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)viewDidUnload
{
    [self setFrameBottom:nil];
    [self setAsset:nil];
    
    [self setTableView:nil];
    [self setVideoAssetVC:nil];

    [self setNavigationDetailV:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
        
    // If we are being presented, lets free up our cached sub-views
    if (self.navigationController.topViewController == self)
    {
        [self setVideoAssetVC:nil];
    }
    
}

#pragma mark - Setters
- (void)setAsset:(SBAsset *)newAsset
{
    asset = newAsset;

    self.title = asset.metadata.name;
    
    [tableView reloadData];
    
}

#pragma mark - Getters
- (ZTTVCTemplateLibrary*)cellTemplateLibrary
{
    if (!cellTemplateLibrary) {
        cellTemplateLibrary = [[ZTTVCTemplateLibrary alloc] initWithNibNamed:@"SBAssetNavigatorCell"];
    }
    
    return cellTemplateLibrary;
}

- (SBVideoAssetVC*)videoAssetVC
{
    if (!videoAssetVC)
    {
        videoAssetVC = [SBVideoAssetVC videoAssetVC];
    }
    
    return videoAssetVC;
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.asset.subAssets count];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SBAsset* currentAsset = [self.asset.subAssets objectAtIndex:indexPath.row];
    
    if (currentAsset.metadata.type == SBAssetFolder)
    {
        SBAssetNavigatorVC *subAssetNavigator = [SBAssetNavigatorVC assetNavigatorWithAsset:currentAsset];
        [self.navigationController pushViewController:subAssetNavigator animated:YES];
    }
    else
    {
        [self.navigationDetailV setAsset:currentAsset];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBAssetNavigatorCell* newCell = [self.cellTemplateLibrary cellOfKind:@"AssetNavigatorCell" forTable:aTableView];
    
    newCell.imageView.image = [UIImage imageNamed:@""];
        
    SBAsset* currentAsset = [self.asset.subAssets objectAtIndex:indexPath.row];
    
    newCell.textLabel.text = currentAsset.metadata.name;
    newCell.backgroundView.backgroundColor = [UIColor lightGrayColor];
    
    return newCell;
}

#pragma mark - IBActions

- (IBAction)enterAnnotationMode:(UIButton*)sender
{
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    
    SBAsset* currentAsset = [self.asset.subAssets objectAtIndex:indexPath.row];
    
   // self.videoAssetVC.assetURL = [[NSBundle mainBundle] URLForResource:@"testVideo" withExtension:@"mov"];
    self.videoAssetVC.asset = currentAsset;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [self.navigationController pushViewController:self.videoAssetVC animated:YES];
    [UIView commitAnimations];   
}

@end
