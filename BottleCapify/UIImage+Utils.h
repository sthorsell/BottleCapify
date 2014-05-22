//
//  Image.h
//  BottleCapify
//
//  Created by Stephen Thorsell on 12/21/12.
//  Copyright (c) 2012 Stephen Thorsell. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 UIImage+AverageColor.h
 */

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

@end

@interface UIImage (imageWithImageScaledToSizeWithSameAspectRatio)

- (UIImage*)imageWithImage:(UIImage*)sourceImage ScaledToSizeWithSameAspectRatio:(CGSize)targetSize;

@end
