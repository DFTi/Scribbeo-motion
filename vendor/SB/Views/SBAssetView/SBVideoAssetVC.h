//
//  SBAssetVC.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/28/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBAssetPlayerVC.h"
#import "SBAssetAnnotationsVC.h"
#import "SBAsset.h"
#import "InfColorPickerController.h"
#import "ZTLinearToolV.h"


typedef enum {
    SBVideoAssetVCFlagNone = 0,
    SBVideoAssetVCFlagDrawing = 1,
    SBVideoAssetVCFlagText = 1 << 1,
    SBVideoAssetVCFlagAudio = 1 << 2,
    SBVideoAssetVCFlagUpdated = 1 << 3
} SBVideoAssetVCFlags;

@interface SBVideoAssetVC : UIViewController <InfColorPickerControllerDelegate, ZTLinearToolVDelegate, UITextViewDelegate>
    
@property (nonatomic, assign) IBOutlet SBAssetPlayerVC* assetPlayerVC;

@property (nonatomic, assign) IBOutlet SBAssetAnnotationsVC* assetAnnotationsVC;

@property (nonatomic, assign) IBOutlet UIToolbar* assetToolbar;

@property (nonatomic, weak) SBAsset* asset;

@property (nonatomic, readonly) SBVideoAssetVCFlags editingMode;

+ (SBVideoAssetVC*)videoAssetVC;

- (void)setCurrentAnnotation:(SBAnnotation*)annotation;

@end
