//
//  CapifyImage.h
//  BottleCapify
//
//  Created by Stephen Thorsell on 1/29/13.
//  Copyright (c) 2013 Stephen Thorsell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Utils.h"

@interface CapifyImage : NSObject
@property (strong) NSMutableArray *colorArray;
- (id) initWithImage: (UIImage*) image TileSize: (float) size;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property UIImage *im;
@property float percentComplete;
@property int tileSize;
@property UIImage *capImage;

- (void) generateCaps;
@end
