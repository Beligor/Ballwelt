//
//  RFMPauseViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 12/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMPauseViewController.h"

@interface RFMPauseViewController ()

@end

@implementation RFMPauseViewController

#pragma mark - Init
-(id)initWithBackGround:(UIImage *) aScreenCapture
             isGameOver:(BOOL)isGameOver
{
    if (self = [self initWithNibName:nil
                              bundle:nil]) {
        _image = aScreenCapture;
        _isGameOver = isGameOver;
    }
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.backGround.image = self.image;
    // Create Queue
    dispatch_queue_t processImage = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    // block to process in background
    dispatch_async(processImage, ^{
        [self applyBlurEffect];
        // execute in Main Queue
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backGround.image = self.image;
        });
        
    });
    [self showMenu];
}

-(void)dealloc{
    NSLog(@"RFMPauseViewController dealloc");
}

#pragma mark - Menu
-(void)showMenu
{
    if (self.isGameOver) {
        [self.button setTitle:@"Game Over"
                     forState:UIControlStateNormal];
    }else{
        [self.button setTitle:@"Pause"
                     forState:UIControlStateNormal];
    }
}


#pragma mark - Blur effect
-(void)applyBlurEffect
{
    // Create a context
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // Create a CIImage
    CIImage *imageToBlur = [CIImage imageWithCGImage:self.image.CGImage];
    
    // Create Blur Effect filter
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur
                          forKey:@"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:5]
                          forKey:@"inputRadius"];
    
    // Output image
    CIImage *output = [gaussianBlurFilter valueForKey:@"outputImage"];
    
    CGImageRef res = [context createCGImage:output
                                   fromRect:[output extent]];
    
    // Assign the result to the image
    self.image = [UIImage imageWithCGImage:res];
    
    // Release the CGIImageRef
    CGImageRelease(res);
}

#pragma mark - Actions
- (IBAction)button:(id)sender {
    UIButton *btn = sender;
    
    
    if ([btn.titleLabel.text isEqual: @"Game Over"]) {
        // Game Over
        [self dismissViewControllerAnimated:NO
                                 completion:nil];
    }else{
        // Pause
        [self dismissViewControllerAnimated:NO
                                 completion:nil];
    }
    
    
    
    
}


@end
