//
//  SBAssetAnnotationsVC.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/28/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "SBAssetAnnotationsVC.h"

#import "SBVideoAssetVC.h"
#import "../Tools/ZTTVCTemplateLibrary.h"
#import "SBAssetAnnotationCell.h"

#import "../Models/SBAnnotation.h"


#pragma mark Class Extension
@interface SBAssetAnnotationsVC ()

#define SBAssetAnnotationsVCTemplateNib @"SBAssetAnnotationCell"
@property (nonatomic, strong) ZTTVCTemplateLibrary *templateLibrary;


@end

#pragma mark - Class Implementation
@implementation SBAssetAnnotationsVC

@synthesize templateLibrary;
@synthesize annotationsTableView;


@synthesize assetPlayerVC;
@synthesize annotations;


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    
    self.annotationsTableView.indicatorPosition = RHHorizontalTableViewScrollIndicatorPositionBottom; 
    
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

#pragma mark - TableView Data Source

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SBAssetAnnotationCell *cell = [self.templateLibrary cellOfKind:@"AnnotationThumbCell" forTable:tableView];
    
    //UIImage *temp = [UIImage imageNamed:@"annotationTempThumb"];
    //cell.frameThumbnail = temp;
    
    SBAnnotation *currentAnnotation = [self.annotations objectAtIndex:indexPath.row];
    
    cell.timecode = currentAnnotation.metadata.timecode;
    
    if (currentAnnotation.metadata.frame) {
        cell.frameThumbnail = [UIImage imageWithData:currentAnnotation.metadata.frame];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.annotations count];
    
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBAnnotation *currentAnnotation = [self.annotations objectAtIndex:indexPath.row];
    SBVideoAssetVC* videoAssetVC = (SBVideoAssetVC*)self.parentViewController;
    
    [videoAssetVC setCurrentAnnotation:currentAnnotation];
    
    [self.assetPlayerVC jumpToAnnotation:currentAnnotation];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 174;
    
}

#pragma mark - Setters

- (void)setAnnotations:(NSArray *)newAnnotations
{
    if (newAnnotations)
    {
        annotations = newAnnotations;
        [self.annotationsTableView reloadData];
    }
}

#pragma mark - Getters

- (ZTTVCTemplateLibrary*)templateLibrary
{
    
    if (!templateLibrary) {
        templateLibrary = [[ZTTVCTemplateLibrary alloc] initWithNibNamed:SBAssetAnnotationsVCTemplateNib];
    }
    
    return templateLibrary;
}

@end
