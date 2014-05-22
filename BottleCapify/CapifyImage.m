//
//  CapifyImage.m
//  BottleCapify
//
//  Created by Stephen Thorsell on 1/29/13.
//  Copyright (c) 2013 Stephen Thorsell. All rights reserved.
//

#import "CapifyImage.h"

@interface CapifyImage ()
@property NSMutableArray *squareImages;
@property NSMutableArray *lValues;
@property NSMutableArray *aValues;
@property NSMutableArray *bValues;
@end

@implementation CapifyImage
@synthesize colorArray = _colorArray;
@synthesize im = _im;
@synthesize squareImages = _squareImages;
@synthesize percentComplete = _percentComplete;
@synthesize tileSize = _tileSize;
@synthesize capImage = _capImage;
@synthesize lValues = _lValues;
@synthesize aValues = _aValues;
@synthesize bValues = _bValues;


- (id) initWithImage: (UIImage*) image TileSize: (float) size
{
    self = [super init];
    if(self == nil){
        return nil;
    }
    
    
    
    _im = [image fixOrientation];
    
    _tileSize = size;
    return self;
}

- (void) generateCaps
{
    NSLog(@"start");
    NSString *currentpath = [[NSBundle mainBundle] bundlePath];
    
    _squareImages = [[NSMutableArray alloc] init];
    _colorArray = [[NSMutableArray alloc] init];
    _lValues = [[NSMutableArray alloc] init];
    _aValues = [[NSMutableArray alloc] init];
    _bValues = [[NSMutableArray alloc] init];
    _percentComplete = 0;
    
    
    NSDictionary *bottleData = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",currentpath, @"/capInfo.plist"]];
    
    size_t bitsPerComponent = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    CGSize s = CGSizeMake(_tileSize, _tileSize);
    CGContextRef context1 = CGBitmapContextCreate(NULL,
                                                  s.width,
                                                  s.height,
                                                  bitsPerComponent,
                                                  0,
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedLast);
    
    double lValues[bottleData.count/4];
    double *ll = lValues;
    double aValues[bottleData.count/4];
    double *aa = aValues;
    double bValues[bottleData.count/4];
    double *bb = bValues;
    
    for(int i = 1; i <= bottleData.count/4; i++){
        NSString *capID = [NSString stringWithFormat:@"im%i", i];
        NSString *curValue = [bottleData objectForKey:[capID stringByAppendingString:@"File"]];
        UIImage *bud = [UIImage imageWithContentsOfFile:[currentpath stringByAppendingString:curValue ]];

        _capImage = bud;
        CGLayerRef clx = CGLayerCreateWithContext(context1, s, NULL);
        CGContextRef cacheContext = CGLayerGetContext(clx);
        
        CGContextDrawImage(cacheContext, CGRectMake(0, 0, _tileSize, _tileSize) , bud.CGImage);
        
        
        
        float red = [[bottleData objectForKey:[capID stringByAppendingString:@"R"]] floatValue];
        float green = [[bottleData objectForKey:[capID stringByAppendingString:@"G"]] floatValue];
        float blue = [[bottleData objectForKey:[capID stringByAppendingString:@"B"]] floatValue];
       
        float l = 0.0;
        float a = 0.0;
        float b = 0.0;
        RGB2LAB(red, green, blue, &l, &a, &b);
//        [_lValues addObject:[NSNumber numberWithFloat:l]];
//        [_aValues addObject:[NSNumber numberWithFloat:a]];
//        [_bValues addObject:[NSNumber numberWithFloat:b]];
        lValues[i-1] = l;
        aValues[i-1] = a;
        bValues[i-1] = b;
//        [colorIndexArray addObject:[NSNumber numberWithFloat:budValue]];
        
        [_colorArray addObject:(__bridge id)(clx)];
        
        
    }
    
    CGContextRelease(context1);
    
    int numberOfSectionsWide = _im.size.width/_tileSize;
    int numberOfSectionsTall = _im.size.height/_tileSize;

    
    
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(_im.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);

    
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 _im.size.width,
                                                 _im.size.height,
                                                 CGImageGetBitsPerComponent(_im.CGImage),
                                                 0,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    
    
    
    
    
    for(int i = 0; i < numberOfSectionsWide; i++){
        float ii = i;
        float nn = numberOfSectionsWide;
        _percentComplete = ii/nn;
        dispatch_apply(numberOfSectionsTall, dispatch_get_global_queue(0, 0), ^(size_t j){
            
            int counts[13] = {0,0,0,0,0,0,0,0,0,0,0,0,0};
            
            for(int y = 0; y < _tileSize; y += _tileSize/6){
                for(int z = 0; z < _tileSize; z += _tileSize/6){
                    
                    int h = i*_tileSize + y;
                    int k = numberOfSectionsTall*_tileSize -  j*_tileSize - z;
                    int pixelInfo = ((_im.size.width  * k) + h) * 4;
                    UInt8 imageRed = data[pixelInfo];
                    UInt8 imageGreen = data[(pixelInfo + 1)];
                    UInt8 imageBlue = data[pixelInfo + 2];
                    float lcolor = 0.0;
                    float acolor = 0.0;
                    float bcolor = 0.0;
                    
                    RGB2LAB(imageRed, imageGreen, imageBlue, &lcolor, &acolor, &bcolor);
                        
                    int lowestIndex = 0;
                    double lowest = 100;
                    for(int z = 0; z < 13; z++){
                                
                        double lo = cie94(lcolor, acolor, bcolor, ll[z], aa[z], bb[z]);
                        if(lo < lowest){
                            lowestIndex = z;
                            lowest = lo;
                        }
                    }
                    counts[lowestIndex] += 1;                    
                    
                }
                
            }
            
            int highest = 0;
            for(int zz = 0; zz < 13; zz++){
                if(counts[zz] > counts[highest]){
                    highest = zz;
                }
            }
            
            @synchronized(self) {
                CGContextDrawLayerAtPoint(context, CGPointMake(i*_tileSize, j*_tileSize), (__bridge CGLayerRef)([_colorArray objectAtIndex:highest]));
            }
        });
    }
    
    CGImageRef res = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *resultingImage = [UIImage imageWithCGImage:res];
    NSLog(@"done");
    if(resultingImage.size.width > 960){
        resultingImage = [resultingImage imageWithImage:resultingImage ScaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)];
    }
    
    
    _im = resultingImage;
    
    _percentComplete = 1.0;
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(res);
    CFRelease(pixelData);
    for(id cl in _colorArray){
        CGLayerRelease((__bridge CGLayerRef)(cl));
    }
}


double cie94(double l1, double a1, double b1, double l2, double a2, double b2)
{

	double WHTL = 1.0;double WHTC = 1.0; double WHTH = 1.0;          
	double xDH = 0.0;
	double xC1 = sqrt( ( pow(a1, 2) ) + ( pow(b1,2) ) );
	double xC2 = sqrt( ( pow(a2,2 )) + ( pow(b2,2) ) );
	double xDL = l2 - l1;
	double xDC = xC2 - xC1;
	double xDE = sqrt( ( ( l1 - l2 ) * ( l1 - l2 ) )
                      + ( ( a1 - a2 ) * ( a1 - a2 ) )
                      + ( ( b1 - b2 ) * ( b1 - b2 ) ) );
	if ( sqrt( xDE ) > ( sqrt( abs( xDL ) ) + sqrt( abs( xDC ) ) ) ) {
		xDH = sqrt( ( xDE * xDE ) - ( xDL * xDL ) - ( xDC * xDC ) );
	}
	else {
		xDH = 0;
	}
	double xSC = 1 + ( 0.045 * xC1 );
	double xSH = 1 + ( 0.015 * xC1 );
	xDL /= WHTL;
	xDC /= WHTC * xSC;
	xDH /= WHTH * xSH;
	return sqrt( pow(xDL, 2) + pow(xDC, 2) + pow(xDH, 2) );
}

void RGB2LAB(float r, float g, float b, float* outL, float* outA, float* outB)
{
	
	double var_R = ( r / 255 );        //R from 0 to 255
	double var_G = ( g / 255 ) ;       //G from 0 to 255
	double var_B = ( b / 255 )  ;      //B from 0 to 255
    
	if ( var_R > 0.04045 ) {
		var_R = pow(( ( var_R + 0.055 ) / 1.055 ), 2.4);
	}
	else
		var_R = var_R / 12.92;
	if ( var_G > 0.04045 )
		var_G = pow(( ( var_G + 0.055 ) / 1.055 ), 2.4);
	else
		var_G = var_G / 12.92;
	if ( var_B > 0.04045 )
		var_B = pow(( ( var_B + 0.055 ) / 1.055 ),2.4);
	else
		var_B = var_B / 12.92;
    
	var_R = var_R * 100;
	var_G = var_G * 100;
	var_B = var_B * 100;
    
	double X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
	double Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
	double Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;
    
	double var_X = X / 95.047;          
	double var_Y = Y / 100.00;          
	double var_Z = Z / 108.883;          
	
	if ( var_X > 0.008856 )
		var_X = pow(var_X, ( 1.0/3 ));
	else
		var_X = ( 7.787 * var_X ) + ( 16.0 / 116 );
	if ( var_Y > 0.008856 )
		var_Y = pow(var_Y , ( 1.0/3 ));
	else
		var_Y = ( 7.787 * var_Y ) + ( 16.0 / 116 );
	if ( var_Z > 0.008856 )
		var_Z = pow(var_Z , ( 1.0/3 ));
	else
		var_Z = ( 7.787 * var_Z ) + ( 16.0 / 116 );
	
	
	double CIEL = ( 116.0 * var_Y ) - 16.0;
	double CIEa = 500.0 * ( var_X - var_Y );
	double CIEb = 200.0 * ( var_Y - var_Z );
	*outL = CIEL;
    *outA = CIEa;
    *outB = CIEb;
    
}




@end
