//
//  SBAssetVC.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 11/28/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "SBVideoAssetVC.h"

#import "CustomViews/SBAssetPlayerTimecodeV.h"

#import "../Tools/UIView+Additions.h"
#import "../Tools/UIToolbar+Items.h"
#import "../Tools/UIImage_AutoResizing.h"
#import "../Tools/UIView+Rendering.h"
#import "../Tools/CoreMedia_Timecodes.h"

#import "../Models/SBAnnotation.h"

#import "CustomViews/ZTDrawView.h"

#import <QuartzCore/QuartzCore.h>


#pragma mark Class Extension

@interface SBVideoAssetVC ()
{
    BOOL assetNeedsSetting;
    
}

@property (nonatomic, assign) IBOutlet UIView* assetPlayerFrame;
@property (nonatomic, assign) IBOutlet SBAssetPlayerTimecodeV *assetPlayerTimecode;
@property (nonatomic, assign) IBOutlet UIView* assetAnnotationsFrame;

@property (nonatomic, strong) ZTDrawView *drawingOverlay;
@property (nonatomic, strong) ZTLinearToolV *linearTool;
@property (nonatomic, strong) IBOutlet UISlider *playerScrubber;

//Drawing ToolbarItems
@property (nonatomic, strong) UIBarButtonItem *brushToolbarItem;
@property (nonatomic, strong) InfColorPickerController* colorPickerController;
@property (nonatomic, strong) UIPopoverController *colorPopoverController;

@property (nonatomic) CGRect assetPlayerVCFrameCache;
@property (nonatomic, strong) IBOutlet UIView *textInputView;
@property (nonatomic, strong) IBOutlet UITextView* textView;

@property (nonatomic, readwrite) SBVideoAssetVCFlags annotationFlags;
@property (nonatomic, readwrite) SBVideoAssetVCFlags editingMode;


@property (nonatomic)         BOOL          isNewAnnotation;
@property (nonatomic, strong) SBAnnotation* currentAnnotation;

- (void)toggleDrawing:(id)sender;
- (void)toggleTextInput:(id)sender;
- (void)toggleLinearTool:(id)sender;

- (void)presentColorPopover:(id)sender;

- (NSIndexPath*)findIndexPathOf:(SBAnnotation*)annotation;
- (SBAnnotation*)annotationForTimecode:(NSString*)timecode;

- (void)annotationSwipeUp:(UISwipeGestureRecognizer*)swipeRecognizer;

@end

#pragma mark - Class Implementation

@implementation SBVideoAssetVC

#pragma mark - Private properties

@synthesize assetPlayerFrame;
@synthesize assetPlayerTimecode;
@synthesize assetAnnotationsFrame;

@synthesize drawingOverlay;
@synthesize linearTool;
@synthesize playerScrubber;

@synthesize brushToolbarItem;
@synthesize colorPickerController;
@synthesize colorPopoverController;

@synthesize assetPlayerVCFrameCache;
@synthesize textInputView;
@synthesize textView;

@synthesize annotationFlags;
@synthesize editingMode;

@synthesize isNewAnnotation;
@synthesize currentAnnotation;

#pragma mark - Public properties

@synthesize assetPlayerVC;
@synthesize assetAnnotationsVC;
@synthesize assetToolbar;

@synthesize asset;

#pragma mark - View lifecycle

+ (SBVideoAssetVC*)videoAssetVC
{
    return [[SBVideoAssetVC alloc] initWithNibName:@"SBVideoAssetVC" bundle:[NSBundle mainBundle]];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)viewDidLoad
{
    //Landscape - Navbar - statusbar

    [self.playerScrubber setMinimumTrackImage:[UIImage imageNamed:@"scrubberTrackMin"] forState:UIControlStateNormal];
    [self.playerScrubber setThumbImage:[UIImage imageNamed:@"scrubberPlayhead"] forState:UIControlStateNormal];
    [self.playerScrubber setMaximumTrackImage:[UIImage imageNamed:@"scrubberTrack"] forState:UIControlStateNormal];
    
    // Add player and set it's frame
    [self addChildViewController:self.assetPlayerVC];
    [self.assetPlayerVC setScrubber:self.playerScrubber];
    self.assetPlayerVCFrameCache = self.assetPlayerFrame.frame;
    [self.assetPlayerFrame replaceWithView:self.assetPlayerVC.view];
    
    [self.assetPlayerVC addObserver:self forKeyPath:@"currentTimecode" options:0 context:nil];
    self.assetPlayerTimecode.timecode = @"00:00:00;00";
    // Cleanup placeholder frame
    self.assetPlayerFrame = nil;
    
    self.assetAnnotationsVC.assetPlayerVC = self.assetPlayerVC;
    [self.view bringSubviewToFront:self.assetAnnotationsVC.view];
    
    // Add annotations and set it's frame
    [self addChildViewController:self.assetAnnotationsVC];
    [self.assetAnnotationsFrame replaceWithView:self.assetAnnotationsVC.view];
    // Cleanup placeholder frame
    self.assetAnnotationsFrame = nil;
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(annotationSwipeUp:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.assetAnnotationsVC.view addGestureRecognizer:swipeRecognizer];
    
    if (assetNeedsSetting) 
    {
        
        [self.asset.annotations sortUsingComparator:(NSComparator)^(SBAnnotation* a, SBAnnotation* b){
            Float64 aSec = CMTimecodeGetSeconds(CMTimecodeFromNSString(a.metadata.timecode, self.assetPlayerVC.framerate));
            Float64 bSec = CMTimecodeGetSeconds(CMTimecodeFromNSString(b.metadata.timecode, self.assetPlayerVC.framerate));
            
            if (aSec < bSec) {
                return NSOrderedAscending;
            }
            else if (aSec > bSec){
                return NSOrderedDescending;
            }
            
            return NSOrderedSame;
            
        }];
        [self.assetAnnotationsVC setAnnotations:asset.annotations];
        
        self.assetPlayerVC.assetURL = [NSURL URLWithString:self.asset.metadata.url];
    }
    
    //UIImage *assetToolbarBackground = [UIImage imageNamed:@"toolbarBG"];
    UIImage *assetToolbarBackground = [UIImage autoResizingImageNamed:@"toolbarDepthBG"];
    [self.assetToolbar setBackgroundImage:assetToolbarBackground forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    // Load up test movie
    //self.assetPlayerVC.assetURL = [NSURL URLWithString:@"http://studioview.turner.com/studioview/upload/13316070440134e46c2/NoTCTrim2.mov"];//[[NSBundle mainBundle] URLForResource:@"testVideo" withExtension:@"mov"];
    //self.title = @"testNDF.mov";
    
    #ifdef DEBUG
        /*
    //Load test annotation
    NSData* testAnnotationData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testAnnotation" ofType:@"json"]];
    SBAnnotation* testAnnotation = [SBAnnotation annotationWithJSONData:testAnnotationData];
    
    [self.annotations addObject:testAnnotation];
    
    NSData* serializeTest = [testAnnotation serializeToJSONData];

         */
    #endif
    
    //Setup Drawing view
    self.drawingOverlay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.drawingOverlay.contentMode = UIViewContentModeScaleToFill;
    
    //Setup text input view
    [self.view insertSubview:self.textInputView aboveSubview:self.assetPlayerVC.view];
    self.textInputView.hidden = YES;
    CGRect newTextInputFrame = self.textInputView.frame;
    newTextInputFrame.origin.x = -350;
    self.textInputView.frame = newTextInputFrame;
    self.textView.delegate = self;
    
    //Build Add annotation button spread radial tool
    
    UIButton *addAnnotationButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.navigationItem.rightBarButtonItem.customView = addAnnotationButton;
    addAnnotationButton.frame = CGRectMake(0, 0, 33, 33);
    
    //[addAnnotationButton addTarget:self action:@selector(toggleLinearTool:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.linearTool setToggleButton:addAnnotationButton];
    [self.linearTool setDelegate:self];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.linearTool];
            
    
    for (UIBarButtonItem *currentItem in [self.assetToolbar items])
    {
        [currentItem setBackgroundVerticalPositionAdjustment:3.f forBarMetrics:UIBarMetricsDefault];
    }
    

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([object isKindOfClass:[SBAssetPlayerVC class]] && [keyPath isEqualToString:@"currentTimecode"])
    {
        self.assetPlayerTimecode.timecode = NSStringFromCMTimecode([object currentTimecode]);
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [self setAssetToolbar:nil];
    [self setAssetPlayerTimecode:nil];
    [self setAssetPlayerVC:nil];
    [self setAssetAnnotationsVC:nil];
    [self setPlayerScrubber:nil];
    [self setTextInputView:nil];
    [self setLinearTool:nil];
    
    [super viewDidUnload];
}

#pragma mark - Interface

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Callbacks

- (void)willPresentlinearTool:(ZTLinearToolV *)linearTool
{
    //Stop playing
    [self.assetPlayerVC pause];
    
    //create new annotation or get annotation for current timecode
    NSString* currentTimecodeString = NSStringFromCMTimecode(self.assetPlayerVC.currentTimecode);
    self.currentAnnotation = [self annotationForTimecode:currentTimecodeString];
    
    if (!self.currentAnnotation)
    {//Do we need to make new annotation or edit existing?
        self.currentAnnotation = [[SBAnnotation alloc] init];
        self.isNewAnnotation = YES;
        self.currentAnnotation.metadata.timecode = currentTimecodeString;
        self.currentAnnotation.metadata.author = @"UserManager.author.name";
    }
    
}

- (void)willDismisslinearTool:(ZTLinearToolV *)linearTool
{
        
    if (self.annotationFlags == SBVideoAssetVCFlagNone)
    {
        return;
    }
    
    if (self.annotationFlags & SBVideoAssetVCFlagDrawing)
    {//Save Drawing
        
        self.currentAnnotation.data.drawing = [self.drawingOverlay SVGRepresentation];
    }
    
    if (self.annotationFlags & SBVideoAssetVCFlagText)
    {//Save Text
        
    }
    
    if (self.annotationFlags & SBVideoAssetVCFlagAudio)
    {//Save Audio
        
    }
    
    if (self.isNewAnnotation && self.annotationFlags != SBVideoAssetVCFlagNone)
    {
                
        //dispatch_async(
           //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), 
           //^{
           UIGraphicsBeginImageContext(self.assetPlayerVC.view.bounds.size);

           UIImage* frame = [self.assetPlayerVC captureFrame];
           UIImage* drawing = [self.drawingOverlay screenShotInRect:self.assetPlayerVC.view.bounds];
           
           [frame drawInRect:self.assetPlayerVC.view.bounds];
           [drawing drawInRect:self.assetPlayerVC.view.bounds];
           
           self.currentAnnotation.metadata.frame = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
           
           UIGraphicsEndImageContext();
         //  }
       // );
        
        
        NSIndexPath *indexPath = [self findIndexPathOf:self.currentAnnotation];
        [self.assetAnnotationsVC.annotationsTableView beginUpdates];
        
        [self.assetAnnotationsVC.annotationsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [self.asset.annotations insertObject:self.currentAnnotation atIndex:indexPath.row];
        [self.assetAnnotationsVC.annotationsTableView endUpdates]; 
        
        self.isNewAnnotation = NO;
    }
    else 
    {
        self.currentAnnotation = nil;
        self.isNewAnnotation = NO;
    }
    
    [self.drawingOverlay clearDrawing];
    self.editingMode = SBVideoAssetVCFlagNone;
    
}


- (void)setEditingMode:(SBVideoAssetVCFlags)newEditingMode
{
    
    void (^toggleBlock)() = ^(){
        
        switch (self.editingMode)
        {
            case SBVideoAssetVCFlagDrawing:
                [self toggleDrawing:nil];
                break;
                
            case SBVideoAssetVCFlagText:
                [self toggleTextInput:nil];
                break;
                
            default:
                break;
        }
        
    };
    
    NSLog(@"EditingMode: %i -> %i", editingMode, newEditingMode);
    
    if (editingMode != newEditingMode)
    {
        //Toggle off old mode
        toggleBlock();
        
        editingMode = newEditingMode;
        
        //Toggle on new mode
        //toggleBlock();
    }
}

- (void)toggleDrawing:(id)sender
{
        
    if (self.drawingOverlay.superview)
    {
        //editingMode = SBVideoAssetVCFlagNone;
        if (self.drawingOverlay.hasInput)
        {//Add drawing flag if we have input
            self.annotationFlags |= SBVideoAssetVCFlagDrawing;
        }
        
        [self.drawingOverlay removeFromSuperview];
        [self.assetToolbar removeBarButtonItem:self.brushToolbarItem animated:YES];
    }
    else
    {
        self.editingMode = SBVideoAssetVCFlagDrawing;
        
        self.drawingOverlay.frame = self.assetPlayerVC.view.bounds;
        [self.assetPlayerVC.view addSubview:self.drawingOverlay];
        [self.assetToolbar addBarButtonItemRight:self.brushToolbarItem animated:YES];
    }
    
}

- (void)toggleTextInput:(id)sender
{
    
    if (self.textInputView.hidden)
    {        
        
        self.editingMode = SBVideoAssetVCFlagText;
                
        self.textInputView.hidden = NO;
        self.assetPlayerVC.controlsDisabled = YES;
        
        [self.textView becomeFirstResponder];
        
        [UIView animateWithDuration:0.25f delay:0.08f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
            
            CGRect newFrame = self.textInputView.frame;
            newFrame.origin.x = 4;
            self.textInputView.frame = newFrame;
            
            self.assetPlayerVC.view.frame = CGRectMake(358, 0, 659, 374);
            
        }  completion:^(BOOL finished){}];
        
    }
    else
    {
        //editingMode = SBVideoAssetVCFlagNone;
        if ([self.textView.text length] > 0)
        {
            self.annotationFlags |= SBVideoAssetVCFlagText;
        }
        
        [self.textView resignFirstResponder];
        
        [UIView animateWithDuration:0.18f animations:^(){
            
            CGRect newFrame = self.textInputView.frame;
            newFrame.origin.x = -354;
            self.textInputView.frame = newFrame;
            
            self.assetPlayerVC.view.frame = self.assetPlayerVCFrameCache;
            
        }
         completion:^(BOOL finished){
             self.textInputView.hidden = YES;
             self.assetPlayerVC.controlsDisabled = NO;
         }];
    }
}

- (void)presentColorPopover:(id)sender
{
    
    if (self.colorPopoverController.isPopoverVisible)
    {
        [self.colorPopoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [self.colorPopoverController setPopoverContentSize:self.colorPickerController.view.frame.size];
        
        [self.colorPopoverController presentPopoverFromBarButtonItem:self.brushToolbarItem permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];   
    }
}

- (void)annotationSwipeUp:(UISwipeGestureRecognizer*)swipeRecognizer
{
    //[UIView animateWithDuration:0.5f animations:^(){
       // self.assetAnnotationsVC.annotationsTableView.rotation = 0.f;
        [self.assetAnnotationsVC.annotationsTableView reloadData];
   // }];
}

#pragma mark - Mutators


#pragma mark - Setters


- (void)setAsset:(SBAsset *)newAsset
{
    
    asset = newAsset;

    if (newAsset) 
    {
        self.playerScrubber.value = 0;

        if (!self.assetAnnotationsVC)
        {
            assetNeedsSetting = YES;
        }
        else
        {
            [self.asset.annotations sortUsingComparator:(NSComparator)^(SBAnnotation* a, SBAnnotation* b){
                Float64 aSec = CMTimecodeGetSeconds(CMTimecodeFromNSString(a.metadata.timecode, self.assetPlayerVC.framerate));
                Float64 bSec = CMTimecodeGetSeconds(CMTimecodeFromNSString(b.metadata.timecode, self.assetPlayerVC.framerate));
                
                if (aSec < bSec) {
                    return NSOrderedAscending;
                }
                else if (aSec > bSec){
                    return NSOrderedDescending;
                }
                
                return NSOrderedSame;

            }];
            [self.assetAnnotationsVC setAnnotations:self.asset.annotations];
            self.assetPlayerVC.assetURL = [NSURL URLWithString:self.asset.metadata.url];

        }
        self.title = self.asset.metadata.name;
    }
    else
    {
        //TODO: clean up asset
    }
}

- (void)setCurrentAnnotation:(SBAnnotation *)newAnnotation
{
    currentAnnotation = newAnnotation;
    self.textView.text = newAnnotation.data.text;
    //[self.drawingOverlay loadSVGRepresentation:newAnnotation.data.drawing];
}

- (NSIndexPath*)findIndexPathOf:(SBAnnotation*)aAnnotation
{
    Float64 nextSeconds = -1.f;
    Float64 currentSeconds = CMTimecodeGetSeconds(CMTimecodeFromNSString(aAnnotation.metadata.timecode, self.assetPlayerVC.framerate));
    NSInteger index = 0;
    
    for (SBAnnotation *a in self.asset.annotations) {
        nextSeconds = CMTimecodeGetSeconds(CMTimecodeFromNSString(a.metadata.timecode, self.assetPlayerVC.framerate));
        if (currentSeconds < nextSeconds) {
            return [NSIndexPath indexPathForRow:index inSection:0];
        }
        else {
            
        }
        index ++;
    }
    
    return [NSIndexPath indexPathForRow:[self.asset.annotations count] inSection:0];
}

- (SBAnnotation*)annotationForTimecode:(NSString*)timecode
{
    
    for (SBAnnotation* aAnnotation in self.asset.annotations)
    {
        if ([aAnnotation.metadata.timecode isEqualToString:timecode])
        {
            return aAnnotation;
        }
    }
    
    return nil;
}

#pragma mark - Getters

- (ZTDrawView*)drawingOverlay
{
    
    if (!drawingOverlay)
    {
        drawingOverlay = [[ZTDrawView alloc] initWithFrame:self.assetPlayerVCFrameCache];
        drawingOverlay.backgroundColor = [UIColor clearColor];
    }
    
    return drawingOverlay;
    
}


- (ZTLinearToolV*)linearTool
{
    if (!linearTool)
    {
        linearTool = [[ZTLinearToolV alloc] initWithFrame:CGRectMake(0, 0, 150, 34)];
        linearTool.backgroundColor = [UIColor clearColor];
        
        UIButton *toggleDraw = [UIButton buttonWithType:UIButtonTypeCustom];
        [toggleDraw addTarget:self action:@selector(toggleDrawing:) forControlEvents:UIControlEventTouchUpInside];
        toggleDraw.frame = CGRectMake(0, 0, 28, 27);
        [toggleDraw setImage:[UIImage imageNamed:@"penTool"] forState:UIControlStateNormal];
        [linearTool addSubview:toggleDraw];
        
        UIButton *toggleTextInput = [UIButton buttonWithType:UIButtonTypeCustom];
        [toggleTextInput addTarget:self action:@selector(toggleTextInput:) forControlEvents:UIControlEventTouchUpInside];
        toggleTextInput.frame = CGRectMake(0, 0, 28, 27);
        [toggleTextInput setImage:[UIImage imageNamed:@"textTool"] forState:UIControlStateNormal];
        [linearTool addSubview:toggleTextInput];
       
        UIButton *toggleAudioRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        [toggleAudioRecord addTarget:self action:@selector(toggleTextInput:) forControlEvents:UIControlEventTouchUpInside];
        toggleAudioRecord.frame = CGRectMake(0, 0, 28, 27);
        [toggleAudioRecord setImage:[UIImage imageNamed:@"audioTool"] forState:UIControlStateNormal];
        [linearTool addSubview:toggleAudioRecord];
        
    }
    
    return linearTool;
}

- (UIBarButtonItem*)brushToolbarItem
{
    if (!brushToolbarItem) {
        brushToolbarItem = [[UIBarButtonItem alloc] initWithTitle:@"color" style:UIBarButtonItemStyleBordered target:self action:@selector(presentColorPopover:)];
        
        [brushToolbarItem setBackgroundVerticalPositionAdjustment:3.f forBarMetrics:UIBarMetricsDefault];
    }
    
    return brushToolbarItem;
}

- (InfColorPickerController*)colorPickerController
{
    if (!colorPickerController) {
        colorPickerController = [[InfColorPickerController alloc] initWithNibName:@"InfColorPickerView" bundle:[NSBundle mainBundle]];
        colorPickerController.delegate = self;
    }
    
    return colorPickerController;
}

- (UIPopoverController*)colorPopoverController
{
    if (!colorPopoverController) {
        colorPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.colorPickerController];
    }
    
    return colorPopoverController;
}

- (SBAssetPlayerVC*)assetPlayerVC
{
    if (!assetPlayerVC)
    {
        assetPlayerVC = [SBAssetPlayerVC assetPlayerVC];
    }
    
    return assetPlayerVC;
}

#pragma mark - InfColorPickerControllerDelegate

- (void)colorPickerControllerDidChangeColor:(InfColorPickerController *)controller
{
    self.drawingOverlay.brushColor = controller.resultColor;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{

}

@end
