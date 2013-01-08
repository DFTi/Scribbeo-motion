//
//  SBAssetAnnotationCell.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/2/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBAssetAnnotationCell : UITableViewCell

@property (nonatomic, strong) UIColor*  categoryColor;
@property (nonatomic, strong) UIImage*  frameThumbnail;
@property (nonatomic, strong)   UIFont*   timecodeFont;
@property (nonatomic, strong) NSString* timecode;

@end
