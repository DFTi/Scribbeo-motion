//
//  SBAssetNavigatorVC.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/8/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../Models/SBAsset.h"

@interface SBAssetNavigatorVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SBAsset* asset;

+ (SBAssetNavigatorVC*)assetNavigatorWithAsset:(SBAsset*)anAsset;

@end
