//
//  RFMPauseViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 12/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMPauseMenuViewController.h"


@interface RFMPauseMenuViewController ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) BOOL isGameOver;
@property (nonatomic) NSInteger score;
@end

@implementation RFMPauseMenuViewController

#pragma mark - Init
-(id)initWithBackGround:(UIImage *) aScreenCapture
             isGameOver:(BOOL) isAGameOver
                  score:(NSInteger) aScore
{
    if (self = [self initWithNibName:nil
                              bundle:nil]) {
        _image = aScreenCapture;
        _isGameOver = isAGameOver;
        _score = aScore;
    }
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.continueBtn.titleLabel.text = NSLocalizedString(@"PAUSE_Continue", nil);
    self.restartBtn.titleLabel.text = NSLocalizedString(@"PAUSE_Restart", nil);
    self.extiBtn.titleLabel.text = NSLocalizedString(@"PAUSE_Exit", nil);
    [self composeMenu];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Create Queue
    dispatch_queue_t processImage = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // block to process in background
    dispatch_async(processImage, ^{
        [self applyBlurEffect];
        // execute in Main Queue
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blurredImage.image = self.image;
            [self showBlur];
        });
        
    });
}

#pragma mark - Utils
-(void)composeMenu
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:self.image]];
    
    self.menuSquare.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundPlayScreen"]];
    [self.menuSquare.layer setCornerRadius:self.menuSquare.frame.size.height/4];
    [self.menuSquare.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.menuSquare.layer setBorderWidth:1.0];
    [self.menuSquare.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.menuSquare.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
    [self.menuSquare.layer setShadowOpacity:1.0f];
    [self.menuSquare.layer setShadowRadius:5.0f];
    
    self.scoreSquare.backgroundColor = self.menuSquare.backgroundColor;
    [self.scoreSquare.layer setCornerRadius:self.scoreSquare.frame.size.height/4];
    [self.scoreSquare.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.scoreSquare.layer setBorderWidth:1.0];
    [self.scoreSquare.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.scoreSquare.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
    [self.scoreSquare.layer setShadowOpacity:1.0f];
    [self.scoreSquare.layer setShadowRadius:5.0f];
    
    self.scoreLbl.text = [NSString stringWithFormat:@"%ld",(long)self.score];
    
    if (self.isGameOver) {
#warning complete this method
        // Hide "Resume" button
        self.continueBtn.hidden = YES;
        // Show Score
        
        // If score is a new record show the label
    }else{
        
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

- (void)showBlur
{
    [UIView animateWithDuration:0.3 animations:^{
        self.blurredImage.alpha = 1.0;
        self.menuSquare.alpha = 0.7;
        self.scoreSquare.alpha = 0.7;
    }];
}

#pragma mark - Actions
-(void)selectedOption:(id)sender
{
    UIButton *btn = sender;
    
    switch (btn.tag) {
        case 0: // Resume
            [self.navigationController popViewControllerAnimated:NO];
            break;
        case 1: // Restart
            [self.delegate pauseMenuWillRestartGame];
            [self.navigationController popViewControllerAnimated:NO];
            break;
        case 2: // Exit
            [self.navigationController popToRootViewControllerAnimated:NO];
            break;
            
        default:
            break;
    }
}

#pragma mark - iAd Delegate Methods
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}

- (void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}
@end
