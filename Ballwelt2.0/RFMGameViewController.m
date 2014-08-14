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
#import "RFMGameTimeBarView.h"
#import "RFMNewBallTimeBarView.h"
#import "RFMPauseMenuViewController.h"
#import "RFMSystemSounds.h"

@interface RFMGameViewController ()
@property (nonatomic, strong) RFMGameTimeBarView *gameBar;
@property (nonatomic, strong) RFMNewBallTimeBarView *ballBar;
@property (nonatomic, strong) RFMGameModel *model;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic) BOOL usedPowerUp;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#warning add a count down
    if (!self.paused) {
        
        [self configureGame];
        
        [self configurarNavigationController];
        
        
        self.gameBar = [[RFMGameTimeBarView alloc] initWithTotalTime:20
                                                               width:self.controlPanelView.frame.size.width
                                                              height:20
                                                            position:CGPointMake(0, 0)
                                                            barColor:Rgb2UIColor(113, 172, 55)];
        
        self.ballBar = [[RFMNewBallTimeBarView alloc] initWithTotalTime:2
                                                                  width:self.gameBar.frame.size.width
                                                                 height:6
                                                               position:CGPointMake(0,self.gameBar.frame.size.height-2)
                                                               barColor:Rgb2UIColor(244, 109, 35)];
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(makeAPause)];
        [oneTap setNumberOfTapsRequired:1];
        [self.gameBar addGestureRecognizer:oneTap];
        
        
        // Delegates
        self.gameBar.delegate = self;
        self.ballBar.delegate = self;
        
        // Add to view
        [self.controlPanelView addSubview:self.gameBar];
        [self.controlPanelView addSubview:self.ballBar];
        
        // Add N balls at the beginin
        for (int i =0; i<5; i++) {
            [self addBallToView];
        }
        
        
        // Start game timer
        [self setUpTimer];
    }else{
        self.paused = NO;
        [self setUpTimer];
    }
    
}

-(void)dealloc
{
    NSLog(@"RFMGameViewController dealloc");
}

#pragma mark - Provisional
-(void)configurarNavigationController
{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addBallToView)];
    
    UIBarButtonItem *speedButton = [[UIBarButtonItem alloc] initWithTitle:@"+Sp"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(speedUpBalls:)];
    UIBarButtonItem *slowButton = [[UIBarButtonItem alloc] initWithTitle:@"Slow"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(slowDownBalls:)];
    UIBarButtonItem *freezeButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(freezeBalls:)];
    UIBarButtonItem *destroyButton = [[UIBarButtonItem alloc] initWithTitle:@"Destroy"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(destroyBallsWithAnimation)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItems = @[slowButton, freezeButton, destroyButton, speedButton];
}

#pragma mark - Game utils
-(void)configureGame
{
    self.model = [[RFMGameModel alloc] init];
    
    self.title = [NSString stringWithFormat:@"0"];    
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
    [self.gameBar syncrhonizeTimeLeftWithBarWidth];
    [self.ballBar syncrhonizeTimeLeftWithBarWidth];
    [self moveBall];
}
#warning mejorar este metodo
// se usa para obligar a las bolas a ser destruidas con animación al pulsar el power up de destruir
// intentar mejorar el metodo con la animación para que este no sea necesario
-(void)destroyBallsWithAnimation
{
    [self destroyAllBallsAnimated:YES];
}


#pragma mark - Actions
-(void)addBallToView
{

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
}

-(void)sumPoints:(NSInteger) points
{
    if (self.usedPowerUp == NO) {
        self.model.score = [self.title intValue];
        
        self.model.score = self.model.score + points * self.model.level;
        self.title = [NSString stringWithFormat:@"%ld", (long)self.model.score];
    }
    
}

-(void)levelUp
{
    self.ballBar.totalTime = 2 * self.model.level;
    self.ballBar.timeLeft  = self.ballBar.totalTime;
    self.ballBar.canCreateNewBalls = NO;
    
    self.gameBar.paused = YES;
    
    self.model.level = self.model.level + 1;
    self.model.maxSpeed = self.model.maxSpeed + 10;
    self.model.minSpeed = self.model.minSpeed + 10;
    
    self.model.maxRadius = self.model.maxRadius - self.model.maxRadius * 0.05;
    self.model.minRadius = self.model.minRadius - self.model.minRadius * 0.05;
   
    
    if (self.model.maxSpeed >= SPEED_LIMIT ) {
        self.model.maxSpeed = SPEED_LIMIT;
    }
    if (self.model.minSpeed >= SPEED_LIMIT ) {
        self.model.minSpeed = SPEED_LIMIT - 1;
    }
    
    if (self.model.maxRadius <= MIN_RADIUS) {
        self.model.maxRadius = MIN_RADIUS +1;
    }
    
    if (self.model.minRadius <= MIN_RADIUS) {
        self.model.minRadius = MIN_RADIUS;
    }
}

#pragma mark - Pause & Game Over Menu
-(void)showMenuNoForPauseYesForGameOver:(BOOL)isGameOver
{
    [self.gameTimer invalidate];
    
    RFMPauseMenuViewController *pauseVC = [[RFMPauseMenuViewController alloc] initWithBackGround: [self screenCapture]
                                                                              isGameOver:isGameOver
                                                                                   score:self.model.score];
    pauseVC.delegate = self;
    
    if (isGameOver) {
        // Destroy this viewController before show menu
        self.view = nil;
    }else{
        self.paused = YES;
    }
    [self presentViewController:pauseVC
                       animated:NO
                     completion:nil];
}
#warning change this method
-(void)makeAPause
{
    [self showMenuNoForPauseYesForGameOver:NO];
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
    self.model.numberOfGameOverBalls = self.model.numberOfGameOverBalls + 1;
    if (self.model.numberOfGameOverBalls < 150) {
        [self addBallToView];
    }else{
        [self.gameTimer invalidate];
        //        sleep(1);
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
            
            CGPoint nextMove = [each moveBall];
            
            // Check if crash each other
            if ([self.model.arrayOfBalls count] > 1 ) {
                for (RFMBallView *collisionedBall in self.playGroundView.subviews){
                    if (each != collisionedBall) {
                        // Calculate distance between these two balls
                        CGFloat distX = nextMove.x - collisionedBall.center.x;
                        CGFloat distY = nextMove.y - collisionedBall.center.y;
                        CGFloat distanceBetweenBalls =sqrt(distX*distX + distY*distY);
                        
                        // It's a collision if the distance between the two centers is minor than the sum of the two radius
                        if (distanceBetweenBalls <= (collisionedBall.radius + each.radius)) {
                            // Calculate the angle collision
                            CGFloat collisionAngleForBall =(atan2(collisionedBall.center.y - nextMove.y, collisionedBall.center.x - nextMove.x) * -180/M_PI);
                            CGFloat collisionAngleForCollisionedBall =(atan2(nextMove.y - collisionedBall.center.y, nextMove.y - collisionedBall.center.x) * -180/M_PI);
                            
                            // Change direction, reduce size and increase speed
                            each.direction = collisionAngleForCollisionedBall;
                            collisionedBall.direction = collisionAngleForBall;

                            [each reducesBallSizeUntilReachThisRadius:self.model.minRadius];
                            
                            [each increaseSpeedWithThisIncrement:self.model.speedIncrement
                                                           until:self.model.maxSpeed];
                            [collisionedBall increaseSpeedWithThisIncrement:self.model.speedIncrement
                                                                      until:self.model.maxSpeed];
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
                [self.gameBar addExtraTime];
                [[RFMSystemSounds shareSystemSounds] correctBall];
            }else{
                [[RFMSystemSounds shareSystemSounds] wrongBall];
            }
        }
    }
}

#pragma mark - Powerups
- (void)speedUpBalls:(id)sender {
    self.model.maxSpeed += 50;
}

- (void)slowDownBalls:(id)sender {
    for (RFMBallView *each in self.playGroundView.subviews) {
        each.speed = each.speed - each.speed/3 * 2;
        each.canIncreaseSpeed = NO;
    }
}
- (void)freezeBalls:(id)sender {
    for (RFMBallView *each in self.playGroundView.subviews) {
        each.speed = 0;
    }
}

- (void)destroyAllBallsAnimated:(BOOL)animated{
    self.usedPowerUp = YES;
    for (RFMBallView *each in self.playGroundView.subviews) {
        if (animated) {
            [self removeBall:each];
        }else{
            [each removeFromSuperview];
        }
    }
    self.usedPowerUp = NO;
}

#pragma mark - delegates
// RFMNewBallTimeBarViewDelegate
-(void)timerBarWilladdNewBall
{
    
    if (self.ballBar.canCreateNewBalls) {
        for (int i = 0; i<self.model.level+1; i++) {
            [self addBallToView];
        }
    }else{
        self.ballBar.canCreateNewBalls = YES;
        self.gameBar.paused = NO;
    }
    
    self.ballBar.totalTime = (float)self.ballBar.totalTime - 0.1;

    if (self.ballBar.totalTime <= 1) {
        [self levelUp];
        [self.ballBar changeToPauseColor];
    }else{
        [self.ballBar changeToNormalColor];
    }
}

// RFMGameTimeBarViewDelegate
-(void)timerBarWillEndGame
{
    self.model.minRadius = 30;
    self.model.maxRadius = 60;
    
    [self.gameTimer invalidate];
    for (RFMBallView *each in self.playGroundView.subviews) {
        each.userInteractionEnabled = NO;
    }
    self.gameBar.userInteractionEnabled = NO;
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.005
                                                      target:self
                                                    selector:@selector(gameOver)
                                                    userInfo:nil
                                                     repeats:YES];
}

// RFMPauseViewControllerDelegate
-(void)pauseMenuWillRestartGame
{
    [self destroyAllBallsAnimated:NO];
    self.model.arrayOfBalls = nil;
    [self.gameBar removeFromSuperview];
    self.gameBar = nil;
    [self.ballBar removeFromSuperview];
    self.ballBar = nil;
    self.paused = NO;
}

-(void)pauseMenuWillExitGame
{
    self.view = nil;
    [self dismissViewControllerAnimated:NO
                             completion:nil];
    [self dismissViewControllerAnimated:NO
                             completion:nil];
}
@end
