//
//  ViewController.m
//  BottleCapify
//
//  Created by Stephen Thorsell on 12/21/12.
//  Copyright (c) 2012 Stephen Thorsell. All rights reserved.
//

#import "CapifyViewController.h"


@interface CapifyViewController ()
@property UIImage *im;
@property NSMutableArray *squareImages;
@end

@implementation CapifyViewController
@synthesize colorArray = _colorArray;
@synthesize im = _im;
@synthesize squareImages = _squareImages;



- (id) initWithImage: (UIImage*) image
{
    self = [super init];
    if(self == nil){
        return nil;
    }
    
    
    _im = image;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView * imageScrollView = [[UIScrollView alloc]init];
    imageScrollView.contentMode = (UIViewContentModeScaleAspectFit);
    imageScrollView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    imageScrollView.maximumZoomScale = 4;
    imageScrollView.minimumZoomScale = .1;
    imageScrollView.clipsToBounds = YES;
    imageScrollView.delegate = self;
    [imageScrollView setBackgroundColor:[UIColor whiteColor]];
    imageScrollView.scrollEnabled = YES;
    UIImageView *uii = [[UIImageView alloc] initWithImage:_im];
    [imageScrollView addSubview:uii];
    self.view = imageScrollView;
    imageScrollView.zoomScale = 320 / _im.size.width;

    
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.view.subviews[0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
