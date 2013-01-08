//
//  SBAssetAnnotationsVC.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/28/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBAssetPlayerVC.h"
#import "../CustomViews/RHHorizontalTableView.h"

@interface SBAssetAnnotationsVC : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) IBOutlet SBAssetPlayerVC* assetPlayerVC;
@property (nonatomic, assign) IBOutlet RHHorizontalTableView *annotationsTableView;
@property (nonatomic, strong) NSArray* annotations;

@end
