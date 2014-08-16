 //
//  RFMGameViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 08/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMGameViewController.h"
#import "RFMGameModel.h"
#import "RFMBallView.h"
#import "RFMPauseMenuViewController.h"
#import "RFMSystemSounds.h"

@interface RFMGameViewController ()
@property (nonatomic, strong) RFMGameModel *model;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic) NSInteger currentScore;
@end

@implementation RFMGameViewController

#pragma mark - init
-(id)init
{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _paused = NO;
    }
    return self;
}

#pragma mark - View Lifecycle

#warning add a count down
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.playGroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundPlayScreen"]];
    if (!self.paused) {
        
        [self configureGame];
        
        // Set Delegates
        self.gameTimeBar.delegate = self;
        self.ballTimeBar.delegate = self;
        self.powerUpView.delegate = self;
        
        // Add N balls at the beginin
        for (int i =0; i<5; i++) {
            [self addBallToView];
        }
    }else{
        self.paused = NO;
    }
    // Start game timer
    [self setUpTimer];
}

#pragma mark - Game utils
-(void)configureGame
{
    self.currentScore = 0;
    
    self.model = [[RFMGameModel alloc] init];

    [self.powerUpView setupPowerup];
    
    [self.gameTimeBar setupBarWithTotalTime:10
                                      color:Rgb2UIColor(113, 172, 55)];
    [self.ballTimeBar setupBarWithTotalTime:0
                                      color:Rgb2UIColor(244, 109, 35)];
    
    self.scoreAnimatedLabel.text = [NSString stringWithFormat:@"0"];
}

-(void)setUpTimer
{
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/RATE_PER_SECOND
                                                      target:self
                                                    selector:@selector(syncMovement)
                                                    userInfo:nil
                                                     repeats:YES];
}

-(void)syncMovement
{
    [self.gameTimeBar syncrhonizeTimeLeftWithBarWidth];
    [self.ballTimeBar syncrhonizeTimeLeftWithBarWidth];
    
    self.currentScore = [self.scoreAnimatedLabel animateFromThisScore:self.currentScore
                                                              toReach:self.model.score
                                                       withMultiplier:self.model.level];
    self.scoreAnimatedLabel.text = [NSString stringWithFormat:@"%ld", (long)self.currentScore];
    [self.powerUpView blink];
    
    [self moveBall];
}

#pragma mark - Actions
-(void)addBallToView
{
#warning put a limit of Balls in each level
//    if ([self.model.arrayOfBalls count] <= self.model.level * 10) {
    RFMBallView *ball = [[RFMBallView alloc] initWithRandomPositioninViewWithWidth:self.playGroundView.frame.size.width
                                                                            Height:self.playGroundView.frame.size.height
                                                                          MinSpeed:self.model.minSpeed
                                                                          maxSpeed:self.model.maxSpeed
                                                                         minRadius:self.model.minRadius
                                                                         maxRadius:self.model.maxRadius];
    // add gesture recognizer
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(didBallTouch:)];
    [oneTap setNumberOfTapsRequired:1];
    [ball addGestureRecognizer:oneTap];
    
    [self.model.arrayOfBalls addObject:ball];
    [self.playGroundView addSubview:ball];
//    }
    
}

-(void)sumPoints:(NSInteger) points
{
        self.model.score = self.model.score + points * self.model.level;
}

-(void)levelUp
{
    self.gameTimeBar.paused = YES;

    self.ballTimeBar.totalTime = 1 + self.model.level;
    self.ballTimeBar.timeLeft = self.ballTimeBar.totalTime;
    self.ballTimeBar.canCreateNewBalls = NO;
    
    
    [self.model levelUpChangesRadiusAndSpeed];
}

#pragma mark - Pause & Game Over Menu
-(void)showMenuNoForPauseYesForGameOver:(BOOL)isGameOver
{
    [self.gameTimer invalidate];
    
    RFMPauseMenuViewController *pauseVC = [[RFMPauseMenuViewController alloc] initWithBackGround: [self screenCapture]
                                                                              isGameOver:isGameOver
                                                                                   score:self.model.score];
    pauseVC.delegate = self;
    self.paused = YES;

    [self.navigationController pushViewController:pauseVC
                                         animated:NO];

}

-(UIImage *)screenCapture
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenCapture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenCapture;
}

-(void)gameOver
{
    static NSInteger numberOfGameOverBalls = 0;
    numberOfGameOverBalls = numberOfGameOverBalls + 1;
//    NSLog(@"contador bolas: %d", contador);
    if (numberOfGameOverBalls < 150) {
        [self addBallToView];
    }else{
        [self.gameTimer invalidate];
        numberOfGameOverBalls = 0;
        [self showMenuNoForPauseYesForGameOver:YES];
    }
}

#pragma mark - Operations with balls
-(void)moveBall
{    
    for (RFMBallView *each in self.playGroundView.subviews) {
        if ([self.model.arrayOfBalls count] > 0 && [self.model.arrayOfBalls objectAtIndex:0] == each) {
            each.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.playGroundView bringSubviewToFront:each];
        }
        
        if (each.speed != 0 ) {

            CGPoint nextMove = [each moveToNextPoint];
            
            if (each.haveToReduceRadius && each.radius > self.model.minRadius) {
                [each reduceBallSizeUntilReachThisRadius:self.model.minRadius
                                           withThisRatio:self.model.reduceRadiusRatio];
                each.haveToReduceRadius = NO;
            }            
            
            // Check if crash each other
            if ([self.model.arrayOfBalls count] > 1 ) {
                for (RFMBallView *collisionedBall in self.playGroundView.subviews){
                    if (each != collisionedBall) {
                        
                        // Calculate distance between these two balls
                        CGFloat distX = nextMove.x - collisionedBall.center.x;
                        CGFloat distY = nextMove.y - collisionedBall.center.y;
                        CGFloat distanceBetweenBalls =sqrt(distX*distX + distY*distY);
                        if (distanceBetweenBalls <= (collisionedBall.radius + each.radius)){
                            
                            collisionedBall.haveToReduceRadius = YES;
                            each.haveToReduceRadius = YES;
                            
                            // Calculate the angle collision
                            CGFloat collisionAngleForBall =(atan2(collisionedBall.center.y - nextMove.y, collisionedBall.center.x - nextMove.x) * -180/M_PI);
                            CGFloat collisionAngleForCollisionedBall =(atan2(nextMove.y - collisionedBall.center.y, nextMove.y - collisionedBall.center.x) * -180/M_PI);
                            
                            // Change direction and increase speed
                            each.direction = collisionAngleForCollisionedBall;
                            collisionedBall.direction = collisionAngleForBall;
                            
                            [each increaseSpeedUntilReachThisSpeed:self.model.maxSpeed
                                                     WithThisRatio:self.model.speedIncrement];
                            
                            [collisionedBall increaseSpeedUntilReachThisSpeed:self.model.maxSpeed
                                                                WithThisRatio:self.model.speedIncrement];
                        }
                        
                    }
                }
                
            }            
            // Check if ball position is inside the screen bounds
            [each checkIfInNextMoveReachLimitOfScreen:nextMove];
        }
    }
    
}

-(void)removeBall:(RFMBallView *) aBall
{
    [aBall destroyWithFadeOut];
    [self.model.arrayOfBalls removeObject: aBall];
    [self sumPoints:aBall.radius];
}

#pragma mark - Balls Touch Handler
-(void)didBallTouch:(UITapGestureRecognizer *) sender
{
    if ([self.gameTimer isValid]) {
        if (sender.state == UIGestureRecognizerStateRecognized) {
            if ([self.model.arrayOfBalls objectAtIndex:0] == sender.view) {
                // If the touched Ball is highlighted then
                [self removeBall:[self.model.arrayOfBalls objectAtIndex:0]];
                [self.gameTimeBar addExtraTime];
                [[RFMSystemSounds shareSystemSounds] correctBall];
                [self.powerUpView increaseFillsCircle];
            }else{
                [[RFMSystemSounds shareSystemSounds] wrongBall];
                [self.powerUpView restartPowerUp];
            }
        }
    }
}

#pragma mark - Powerups
- (void)slowDownBalls
{
    for (RFMBallView *each in self.playGroundView.subviews) {
        each.speed = each.speed - each.speed / 3 * 2;
        each.canIncreaseSpeed = NO;
    }
}
- (void)freezeBalls
{
    for (RFMBallView *each in self.playGroundView.subviews) {
        each.speed = 0;
    }
}

- (void)destroyAllBallsAnimated:(BOOL)animated
{
    for (RFMBallView *each in self.playGroundView.subviews) {
        if (animated) {
            [self removeBall:each];
        }else{
            [each removeFromSuperview];
        }
    }
}

#pragma mark - delegates
// RFMNewBallTimeBarViewDelegate
-(void)timerBarWilladdNewBall
{
    if (self.ballTimeBar.canCreateNewBalls) {
        for (int i = 0; i<self.model.level; i++) {
            [self addBallToView];
        }
    }else{
        self.ballTimeBar.canCreateNewBalls = YES;
        self.gameTimeBar.paused = NO;
        [self timerBarWilladdNewBall];
    }
    
    self.ballTimeBar.totalTime = (float)self.ballTimeBar.totalTime - 0.1;

    if (self.ballTimeBar.totalTime <= 1) {
        [self levelUp];
        [self.ballTimeBar changeToPauseColor];
    }else{
        [self.ballTimeBar changeToNormalColor];
    }
}

// RFMGameTimeBarViewDelegate
-(void)timerBarWillEndGame
{
    [self.gameTimer invalidate];
    self.model.minRadius = 20;
    self.model.maxRadius = 70;

    for (RFMBallView *each in self.playGroundView.subviews) {
        each.userInteractionEnabled = NO;

    }
    self.gameTimeBar.userInteractionEnabled = NO;
    
    // Configure timer to call method that show Game Over animation
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.005
                                                      target:self
                                                    selector:@selector(gameOver)
                                                    userInfo:nil
                                                     repeats:YES];
}

-(void)timeBarDidTouched
{
    [self showMenuNoForPauseYesForGameOver:NO];
}

// RFMPauseViewControllerDelegate
-(void)pauseMenuWillRestartGame
{
    [self destroyAllBallsAnimated:NO];
    self.model.arrayOfBalls = nil;
    self.paused = NO;
}

// RFMPowerupBallViewDelegate
-(void)powerUpDidUsed{
    switch (self.powerUpView.powerupNumber) {
        case 1:
            [self slowDownBalls];
            break;
        case 2:
            [self freezeBalls];
            break;
        case 3:
            [self destroyAllBallsAnimated:YES];
            break;
        default:
            break;
    }
}
@end
