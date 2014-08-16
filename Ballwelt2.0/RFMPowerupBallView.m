//
//  RFMPowerupBallView.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 15/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMPowerupBallView.h"
#define NUMBER_OF_LEVELS_NEEDED 10
@interface RFMPowerupBallView()

@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) UIView *fillsCircleView;
@property (nonatomic, strong) UIImageView *currentPowerIcon;
@property (nonatomic, strong) UIColor *filledColor;
@property (nonatomic) CGFloat incrementFraction;
@property (nonatomic) NSInteger currentLevel;
@property (nonatomic) BOOL canBlink;
@property (nonatomic) BOOL isBlinking;

@end

@implementation RFMPowerupBallView

#pragma mark - Init
-(id) initWithRadius:(NSInteger)aRadius
{
    if (self = [super initWithFrame:CGRectMake(0, 0, aRadius * 2, aRadius * 2)]) {
        [self setupPowerup];
    }
    return  self;
    
}


#pragma mark - Setup Ball
-(void) setupPowerup
{
    _filledColor = Rgb2UIColor(113, 172, 55);
    _powerupNumber = 0;
    _icons = @[@"power1", @"power2", @"power3"];
    _incrementFraction = self.frame.size.width / NUMBER_OF_LEVELS_NEEDED;
    _currentLevel = 0;
    _isBlinking = NO;
    _canBlink = NO;
    
    // Remove previous images for realoading
    [self.fillsCircleView removeFromSuperview];
    self.fillsCircleView = nil;
    [self.currentPowerIcon removeFromSuperview];
    self.currentPowerIcon = nil;
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.frame.size.height / 2;
    [self.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.layer setBorderWidth:2.0];
    
    self.fillsCircleView = [[UIView alloc]init];
    self.fillsCircleView.backgroundColor = self.filledColor;
    [self redrawFillsCircle];
    [self addSubview: self.fillsCircleView];
    
    _currentPowerIcon = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:_currentPowerIcon];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(touched:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
}

#pragma mark - Actions
-(void)touched:(UITapGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateRecognized) {
        if (self.powerupNumber > 0) {
            [self.delegate powerUpDidUsed];
            [self restartPowerUp];
        }
    }
}

-(void)increaseFillsCircle
{
    if (self.currentLevel < NUMBER_OF_LEVELS_NEEDED) {
        self.currentLevel = self.currentLevel + 1;
        if (self.currentLevel == NUMBER_OF_LEVELS_NEEDED && self.powerupNumber < 3) {
            self.canBlink = YES;
            [self changeIcon];
            
            if (self.powerupNumber < 2) { // prevents empty circle in last power
                self.currentLevel = 0;
            }
            self.powerupNumber = self.powerupNumber +1;
        }
        [self redrawFillsCircle];
    }
}

#pragma mark - Utils
-(void) redrawFillsCircle
{
    [self.fillsCircleView setFrame:CGRectMake(0, 0, self.currentLevel * self.incrementFraction, self.currentLevel * self.incrementFraction)];
    self.fillsCircleView.layer.cornerRadius = self.fillsCircleView.frame.size.height / 2;
    self.fillsCircleView.center = self.center;
}

-(void)restartPowerUp
{
    self.currentLevel = 0;
    self.powerupNumber = 0;
    self.currentPowerIcon.image = nil;
    self.canBlink = NO;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    [self redrawFillsCircle];
}

-(void)changeIcon
{
    self.currentPowerIcon.image = [UIImage imageNamed:[self.icons objectAtIndex:self.powerupNumber]];
}

- (void)blink
{
    if (self.canBlink && !self.isBlinking) {
        if (self.layer.borderColor == [[UIColor blackColor]CGColor]) {
            [self.layer setBorderColor:[[UIColor whiteColor]CGColor]];
        }else{
            [self.layer setBorderColor:[[UIColor blackColor]CGColor]];
        }
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [UIView animateWithDuration:0.8
                              delay:0.0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [self setBackgroundColor:self.superview.backgroundColor];
                         }completion:^(BOOL finished) {
                             self.isBlinking = NO;
                         }];
        self.isBlinking = YES;
    }

}
@end
