//
//  ImageViewController.h
//  BottleCapify
//
//  Created by Stephen Thorsell on 1/21/13.
//  Copyright (c) 2013 Stephen Thorsell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapifyViewController.h"
#import "CapifyImage.h"

@interface ImageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

- (void) updateProgress;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UISlider *tileSizeSlider;
@property (strong, nonatomic) UIImageView *capImageView;
- (IBAction)libraryClick:(id)sender;
- (IBAction)cameraClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;


@property UIProgressView *uvp;
@property CapifyImage *cap;
@end
