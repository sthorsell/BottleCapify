//
//  MainView.m
//  BottleCapify
//
//  Created by Stephen Thorsell on 12/29/12.
//  Copyright (c) 2012 Stephen Thorsell. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


static void RGB2HSL(float r, float g, float b, float* outH)
{
    r = r/255.0f;
    g = g/255.0f;
    b = b/255.0f;
    
    
    float h,s, l, v, m, vm, r2, g2, b2;
    
    h = 0;
    s = 0;
    l = 0;
    
    v = MAX(r, g);
    v = MAX(v, b);
    m = MIN(r, g);
    m = MIN(m, b);
    
    l = (m+v)/2.0f;
    
    if (l <= 0.0){
        if(outH)
			*outH = h;
        return;
    }
    
    vm = v - m;
    s = vm;
    
    if (s > 0.0f){
        s/= (l <= 0.5f) ? (v + m) : (2.0 - v - m);
    }else{
        if(outH)
			*outH = h;
        return;
    }
    
    r2 = (v - r)/vm;
    g2 = (v - g)/vm;
    b2 = (v - b)/vm;
    
    if (r == v){
        h = (g == m ? 5.0f + b2 : 1.0f - g2);
    }else if (g == v){
        h = (b == m ? 1.0f + r2 : 3.0 - b2);
    }else{
        h = (r == m ? 3.0f + g2 : 5.0f - r2);
    }
    
    h/=6.0f;
    
    if(outH)
        *outH = h;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    // Do any additional setup after loading the view, typically from a nib.
    //    CGRect r = CGRectMake(0,0,15,15);
    NSString *db_path = @"/var/mobile/Applications/C62BD1CE-0699-400C-97E4-FEA6CDB82DCA/BottleCapify.app/im.jpg";
//    UIImage *im = [UIImage imageWithContentsOfFile:@"/Users/Stevo/Developer/BottleCapify/BottleCapify/im.jpg"];
    UIImage *im = [UIImage imageWithContentsOfFile:db_path];
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *docsPath = [paths objectAtIndex:0];
    //    NSString *path = [docsPath stringByAppendingPathComponent:@"datab"];
    
    NSMutableArray *colorIndexArray = [[NSMutableArray alloc] init];
    NSMutableArray *colorArray = [[NSMutableArray alloc] init];
    UIImage *bud = [self imageWithColor:[UIColor whiteColor]];
    UIImage *miller = [self imageWithColor:[UIColor greenColor]];
    //    UIImage *miller1 = [self imageWithColor:[UIColor purpleColor]];
    UIImage *miller2 = [self imageWithColor:[UIColor orangeColor]];
    UIImage *miller3 = [self imageWithColor:[UIColor yellowColor]];
    UIImage *miller4 = [self imageWithColor:[UIColor blueColor]];
    
    
    const CGFloat *components = CGColorGetComponents(bud.averageColor.CGColor);
    float red = components[0];
    float green = components[1];
    float blue = components[2];
    float budValue =0;
    RGB2HSL(red, green, blue, &budValue);
    [colorIndexArray addObject:[NSNumber numberWithFloat:budValue]];
    [colorArray addObject:bud];
    
    components = CGColorGetComponents(miller.averageColor.CGColor);
    red = components[0];
    green = components[1];
    blue = components[2];
    float millerValue = 0;
    RGB2HSL(red, green, blue, &millerValue);
    [colorIndexArray addObject:[NSNumber numberWithFloat:millerValue]];
    [colorArray addObject:miller];
    
    //    components = CGColorGetComponents(miller1.averageColor.CGColor);
    //    red = components[0];
    //    green = components[1];
    //    blue = components[2];
    //    millerValue = red*red + green*green + blue*blue;
    //    [colorIndexArray addObject:[NSNumber numberWithFloat:millerValue]];
    //    [colorArray addObject:miller1];
    
    components = CGColorGetComponents(miller2.averageColor.CGColor);
    red = components[0];
    green = components[1];
    blue = components[2];
    RGB2HSL(red, green, blue, &millerValue);
    
    [colorIndexArray addObject:[NSNumber numberWithFloat:millerValue]];
    [colorArray addObject:miller2];
    
    components = CGColorGetComponents(miller3.averageColor.CGColor);
    red = components[0];
    green = components[1];
    blue = components[2];
    RGB2HSL(red, green, blue, &millerValue);
    [colorIndexArray addObject:[NSNumber numberWithFloat:millerValue]];
    [colorArray addObject:miller3];
    
    components = CGColorGetComponents(miller4.averageColor.CGColor);
    red = components[0];
    green = components[1];
    blue = components[2];
    RGB2HSL(red, green, blue, &millerValue);
    
    [colorIndexArray addObject:[NSNumber numberWithFloat:millerValue]];
    [colorArray addObject:miller4];
    
    
    int numberOfSectionsWide = im.size.width/15;
    int numberOfSectionsTall = im.size.height/15;
    
    //    UIImage* squareImages[91][68];
    NSMutableArray *squareImages = [[NSMutableArray alloc]initWithCapacity:numberOfSectionsWide*numberOfSectionsTall];
    
    
    id gpuImage = [[[GPUImagePicture alloc]init] initWithImage:im];
    CGSize videoPixelSize = CGSizeMake(im.size.width, im.size.height);
    [gpuImage processImage];
    GPUImageRawDataOutput *videoRawData = [[GPUImageRawDataOutput alloc] initWithImageSize:videoPixelSize resultsInBGRAFormat:YES];
    
    [gpuImage addTarget:videoRawData];
    
    
    for(int i = 0; i < numberOfSectionsWide; i++){
        for(int j = 0; j < numberOfSectionsTall; j++){
            //            dispatch_apply(numberOfSectionsTall, dispatch_get_global_queue(0, 0), ^(size_t j){
            
            int h = i*15 + 8;
            int k = j*15 + 8;
            
            
            CGPoint p = CGPointMake(h, k);
            GPUByteColorVector v = [videoRawData colorAtLocation:p];
            float imageRed = [[NSNumber numberWithUnsignedChar:v.red] intValue];
            float imageBlue = [[NSNumber numberWithUnsignedChar:v.blue] intValue];
            float imageGreen = [[NSNumber numberWithUnsignedChar:v.green] intValue];
            
            imageRed = imageRed/255;
            imageBlue = imageBlue/255;
            imageGreen = imageGreen/255;
            
            float newAvgColor = 0;
            RGB2HSL(imageRed, imageGreen, imageBlue, &newAvgColor);
            int closestIndex = 0;
            float closest = 1.0;
            for (int i=0; i < [colorIndexArray count]; i++)
            {
                float num = [[colorIndexArray objectAtIndex:i]floatValue];
                float diff = fabsf(num - newAvgColor);
                
                if (diff < closest)
                {
                    closest = diff;
                    closestIndex = i;
                }
            }
            NSString *info = [NSString stringWithFormat:@"%i;%zi;%i", i,j,closestIndex];
            [squareImages addObject:info];
            NSLog(@"in inner");
            //            }); 
        }
        
        NSLog(@"in outer\n");
    }
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGSize s = CGSizeMake(numberOfSectionsWide*15, numberOfSectionsTall*15);
    UIGraphicsBeginImageContext(s);
    
    for(int i = 0; i < squareImages.count; i++){
        NSArray *tempInfo = [[squareImages objectAtIndex:i]componentsSeparatedByString:@";"];
        
        int ss = [tempInfo[0]intValue];
        int tt = [tempInfo[1]intValue];
        int offset = [tempInfo[2]intValue];
        CGPoint image1Point = CGPointMake(ss*15, tt*15);
        
        [[colorArray objectAtIndex:offset] drawAtPoint:image1Point];
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [resultingImage drawAtPoint:CGPointMake(0,0)];
    // Do your drawing in myContext
}

@end
