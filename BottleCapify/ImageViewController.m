//
//  ImageViewController.m
//  BottleCapify
//
//  Created by Stephen Thorsell on 1/21/13.
//  Copyright (c) 2013 Stephen Thorsell. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property UIViewController *progController;
@end

@implementation ImageViewController
@synthesize uvp = _uvp;
@synthesize cap = _cap;
@synthesize progController = _progController;
@synthesize toolbar = _toolbar;
@synthesize tileSizeSlider = _tileSizeSlider;
@synthesize capImageView = _capImageView;
@synthesize cameraButton = _cameraButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.toolbar.tintColor = [UIColor blackColor];
    
    _uvp = [[UIProgressView alloc] initWithFrame:CGRectMake(30, 160, 260, 9)];
    
    
    _progController = [[UIViewController alloc] init];
    _tileSizeSlider.minimumValue = 18.0;
    _tileSizeSlider.maximumValue = 80.0;
    _tileSizeSlider.value = 30.0;
    
    NSMutableArray *toolbarButtons = [self.toolbar.items mutableCopy];
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [toolbarButtons removeObject:_cameraButton];
        self.toolbar.items = toolbarButtons;
    }
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"black.png" ofType:nil];
    UIImage *bud = [UIImage imageWithContentsOfFile:path1];
    _capImageView = [[UIImageView alloc] initWithImage:bud];
    [self.view addSubview:_capImageView];
    [_capImageView setFrame:CGRectMake(160-16, 160, 32, 32)];
    
    [_tileSizeSlider addTarget:self action:@selector(sliderValueChanged:)
       forControlEvents:UIControlEventValueChanged];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    
}

- (void) viewDidAppear:(BOOL)animated
{
}

- (void) updateProgress
{
    if(_cap == nil){
        return;
    }
    
    [_uvp setProgress:_cap.percentComplete];
    if(_cap.percentComplete == 1.0){
        _cap.percentComplete = 1.1;
        
        [self addCapImage];
        
    }
}



- (IBAction)libraryClick:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil ];
}

- (IBAction)cameraClick:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];    
    
    int s = _tileSizeSlider.value;
    _cap = [[CapifyImage alloc] initWithImage:image TileSize:s];
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("bgqueue", NULL);
    
    
    dispatch_async(backgroundQueue, ^{
        [_cap generateCaps];
    });
    UIView *v = [[UIView alloc] init];
    [v addSubview:_uvp];
    UILabel *progressText = [[UILabel alloc] initWithFrame:CGRectMake(0,100,320,20)];
    progressText.text = @"Processing Image...";
    progressText.textColor = [UIColor whiteColor];
    progressText.backgroundColor = [UIColor blackColor];
    progressText.textAlignment = NSTextAlignmentCenter;
    [_uvp addSubview:progressText];
    [v addSubview:progressText];
    _progController.view = v;
    
    [self presentViewController:_progController animated:NO completion:nil];
    
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.navigationController.view.subviews[0];
}

-(IBAction)sliderValueChanged:(UISlider *)sender
{
    [_capImageView setFrame:CGRectMake(160 - sender.value, 160, sender.value*2, sender.value*2)];
    
}

- (void) addCapImage
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
    CapifyViewController *cvc = [[CapifyViewController alloc] initWithImage:_cap.im];
    [self.navigationController pushViewController:cvc animated:NO];
    

}



@end
