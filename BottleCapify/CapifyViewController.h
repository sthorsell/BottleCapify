//
//  ViewController.h
//  BottleCapify
//
//  Created by Stephen Thorsell on 12/21/12.
//  Copyright (c) 2012 Stephen Thorsell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Utils.h"
#import <QuartzCore/QuartzCore.h>

@interface CapifyViewController : UIViewController <UIScrollViewDelegate>
@property (strong) NSMutableArray *colorArray;
- (id) initWithImage: (UIImage*) image;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end
