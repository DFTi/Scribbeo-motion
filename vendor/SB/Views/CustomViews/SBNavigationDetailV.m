//
//  SBNavigationDetailV.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/12/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "SBNavigationDetailV.h"

@interface SBNavigationDetailV ()

@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* creationDate;
@property (nonatomic, strong) IBOutlet UILabel* annotationCount;
@property (nonatomic, strong) IBOutlet UITextView* description;
@property (nonatomic, strong) IBOutlet UIImageView* preview;


@end

@implementation SBNavigationDetailV

@synthesize name;
@synthesize creationDate;
@synthesize annotationCount;
@synthesize description;
@synthesize preview;

@synthesize asset;

- (void)setAsset:(SBAsset *)newAsset
{
    asset = newAsset;
    
    self.name.text = asset.metadata.name;
    self.creationDate.text = asset.metadata.creationDate;
    self.annotationCount.text = [NSString stringWithFormat:@"%i", [asset.annotations count]];
    self.description.text = asset.metadata.description;
    self.preview.image = [UIImage imageWithData:asset.metadata.preview];
    
}

@end
