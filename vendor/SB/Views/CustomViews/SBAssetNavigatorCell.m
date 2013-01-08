//
//  SBAssetNavigatorCell.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 3/8/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "SBAssetNavigatorCell.h"

#import "UIImage_AutoResizing.h"

@implementation SBAssetNavigatorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
 
    
    
    if (selected)
    {
        self.imageView.image = [UIImage imageNamed:@"film"];
       // self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage autoResizingImageNamed:@"cellSelectedBackground"]];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"filmW"];
    }
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
