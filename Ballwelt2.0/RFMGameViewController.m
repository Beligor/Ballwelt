//
//  RFMGameViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 08/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMGameViewController.h"
#import "RFMBallView.h"
#import "RFMGameTimeBarView.h"
#import "RFMNewBallTimeBarView.h"
#import "RFMPauseViewController.h"
#import "RFMSystemSounds.h"

@interface RFMGameViewController ()
@property (nonatomic, strong) NSMutableArray *arrayOfBalls;
@property (nonatomic, strong) NSTimer *gameTimer;

@property (nonatomic) BOOL usedPowerUp;

@property (nonatomic) NSInteger currentScore;
@property (nonatomic) NSInteger level;

@property (nonatomic) NSInteger minRadius;
@property (nonatomic) NSInteger maxRadius;

@property (nonatomic) CGFloat speedIncrement;
@property (nonatomic) CGFloat maxSpeed;
@property (nonatomic) CGFloat minSpeed;
@property (nonatomic) NSInteger numberOfGameOverBalls;

@property (nonatomic, strong) RFMGameTimeBarView *gameBar;
@property (nonatomic, strong) RFMNewBallTimeBarView *ballBar;
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
    if (!self.paused) {
        [super viewWillAppear:animated];
        
        
        [self configureGame];
        
        [self configurarNavigationController];
        
        
        self.gameBar = [[RFMGameTimeBarView alloc] initWithTotalTime:5
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
                                                                                 action:@selector(pauseMenu)];
        [oneTap setNumberOfTapsRequired:1];
        [self.gameBar addGestureRecognizer:oneTap];
        
        
        // Delegates
        self.gameBar.delegate = self;
        self.ballBar.delegate = self;
        
        // Add to view
        [self.controlPanelView addSubview:self.gameBar];
        [self.controlPanelView addSubview:self.ballBar];
        
        // Add N balls at the beginin
        for (int i =0; i<25; i++) {
            [self addBallToView];
        }
        
        
        // Start game timer
        [self setUpTimer];
    }else{
        self.paused = NO;
        [self setUpTimer];
    }
    
}

-(void)dealloc{
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
                                                                     action:@selector(destroyAllBalls:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItems = @[slowButton, freezeButton, destroyButton, speedButton];
}

#pragma mark - Game utils
-(void)configureGame
{
    self.minRadius = 20;
    self.maxRadius = 30;
    
    self.speedIncrement = 1.3;
    self.minSpeed = 100;
    self.maxSpeed = 150;
    
    self.level = 1;
    
    self.numberOfGameOverBalls = 0;
    
    self.title = [NSString stringWithFormat:@"0"];
    
    self.arrayOfBalls = [[NSMutableArray alloc] init];
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



#pragma mark - Actions
-(void)addBallToView
{

    RFMBallView *ball = [[RFMBallView alloc] initWithRandomPositioninViewWithWidth:self.playGroundView.frame.size.width
                                                                            Height:self.playGroundView.frame.size.height
                                                                          MinSpeed:self.minSpeed
                                                                          maxSpeed:self.maxSpeed
                                                                         minRadius:self.minRadius
                                                                         maxRadius:self.maxRadius];
     // add gesture recognizer
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(didBallTouch:)];
    [oneTap setNumberOfTapsRequired:1];
    [ball addGestureRecognizer:oneTap];
    
    [self.arrayOfBalls addObject:ball];
    [self.playGroundView addSubview:ball];
}

-(void)sumPoints:(NSInteger) points
{
    if (self.usedPowerUp == NO) {
        self.currentScore = [self.title intValue];
        
        self.currentScore = self.currentScore + points * self.level;
        self.title = [NSString stringWithFormat:@"%ld", (long)self.currentScore];
    }
    
}

-(void)levelUp
{
    self.ballBar.totalTime = 2 * self.level;
    self.ballBar.timeLeft  = self.ballBar.totalTime;
    self.ballBar.canCreateNewBalls = NO;
    
    self.gameBar.paused = YES;
    
    self.level = self.level + 1;
    self.maxSpeed = self.maxSpeed + 10;
    self.minSpeed = self.minSpeed + 10;
    
    self.maxRadius = self.maxRadius - 2;
    self.minRadius = self.minRadius - 2;
   
    
    if (self.maxSpeed >= SPEED_LIMIT ) {
        self.maxSpeed = SPEED_LIMIT;
    }
    if (self.minSpeed >= SPEED_LIMIT ) {
        self.minSpeed = SPEED_LIMIT - 1;
    }
    
    if (self.maxRadius <= MIN_RADIUS) {
        self.maxRadius = MIN_RADIUS +1;
    }
    
    if (self.minRadius <= MIN_RADIUS) {
        self.minRadius = MIN_RADIUS;
    }
}

-(void)gameOver
{
    self.numberOfGameOverBalls = self.numberOfGameOverBalls + 1;
    if (self.numberOfGameOverBalls < 150) {
        [self addBallToView];
    }else{
        [self.gameTimer invalidate];
        [self gameOverMenu];
    }
}

#pragma mark - Operations with balls
-(void)moveBall
{    
    for (RFMBallView *each in self.playGroundView.subviews) {
        if ([self.arrayOfBalls count] > 0 && [self.arrayOfBalls objectAtIndex:0] == each) {
            each.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.playGroundView bringSubviewToFront:each];
        }
        
        if (each.speed != 0 ) {
            // speed is expressed in points/seconds
            // RATE_PER_SECOND is the N fraction of a second
            // for each fraction of time, we need to know how many points move at this time
            CGFloat nextMove = each.speed/RATE_PER_SECOND;
            
            // To convert degrees in radiants, it has to be multiplied with Pi/180. The -180 is to have 90º in the superior quadrant.
            CGFloat directionInRadiants = each.direction * M_PI/-180;
            
            // Calculates the next position for this time fraction
            CGFloat nextMoveInX = each.center.x + nextMove * cos(directionInRadiants);
            CGFloat nextMoveInY = each.center.y + nextMove * sin(directionInRadiants);
            
            
            // Check if crash each other
            if ([self.arrayOfBalls count] > 1 ) {
                for (RFMBallView *collisionedBall in self.playGroundView.subviews){
                    if (each != collisionedBall) {
                        // Calculate distance between these two balls
                        CGFloat distX = nextMoveInX - collisionedBall.center.x;
                        CGFloat distY = nextMoveInY - collisionedBall.center.y;
                        CGFloat distanceBetweenBalls =sqrt(distX*distX + distY*distY);
                        
                        // It's a collision if the distance between the two centers is minor than the sum of the two radius
                        if (distanceBetweenBalls <= (collisionedBall.radius + each.radius)) {
                            // Calculate the angle collision
                            CGFloat collisionAngleForBall =(atan2(collisionedBall.center.y - nextMoveInY, collisionedBall.center.x -nextMoveInX) * -180/M_PI);
                            CGFloat collisionAngleForCollisionedBall =(atan2(nextMoveInY - collisionedBall.center.y, nextMoveInX - collisionedBall.center.x) * -180/M_PI);
                            
                            // Change direction, reduce size and increase speed
                            each.direction = collisionAngleForCollisionedBall;
                            collisionedBall.direction = collisionAngleForBall;

                            [each reducesBallSizeUntilReachThisRadius:self.minRadius];
                            
                            [each increaseSpeedWithThisIncrement:self.speedIncrement
                                                           until:self.maxSpeed];
                            [collisionedBall increaseSpeedWithThisIncrement:self.speedIncrement
                                                                      until:self.maxSpeed];
                        }
                        
                    }
                }
                
            }
            
            // Check if ball position is inside the screen bounds
            if (nextMoveInX + each.radius > each.superview.frame.size.width) {
                nextMoveInX = each.superview.frame.size.width - each.radius;
                each.direction = 180 - each.direction;
            }else if (nextMoveInX - each.radius < 0){
                nextMoveInX = each.radius;
                each.direction = (each.direction - 180) * -1;
            }
            
            if (nextMoveInY + each.radius > each.superview.frame.size.height) {
                nextMoveInY = each.superview.frame.size.height - each.radius;
                each.direction *= -1;
            }else if (nextMoveInY - each.radius <0){
                nextMoveInY = each.radius;
                each.direction *=-1;
            }
            
            
            [each setCenter:CGPointMake(nextMoveInX, nextMoveInY)];
        }
    }
    
}

-(void)removeBall:(RFMBallView *) aBall
{
    [aBall destroyWithFadeOut];
    [self.arrayOfBalls removeObject: aBall];
    [self sumPoints:aBall.radius];
}

#pragma mark - Balls Touch Handler
-(void)didBallTouch:(UITapGestureRecognizer *) sender
{
    if ([self.gameTimer isValid]) {
        if (sender.state == UIGestureRecognizerStateRecognized) {
            if ([self.arrayOfBalls objectAtIndex:0] == sender.view) {
                // If the touched Ball is highlighted then
                [self removeBall:[self.arrayOfBalls objectAtIndex:0]];
                [self.gameBar addExtraTime];
                [[RFMSystemSounds shareSystemSounds] correctBall];
            }else{
                [[RFMSystemSounds shareSystemSounds] wrongBall];
            }
        }
    }
    

}

#pragma mark - Pause/Game Over
-(void)pauseMenu
{
    [self showMenuForGameOver:NO];
}

-(void)gameOverMenu
{
    [self showMenuForGameOver:YES];
}

-(void)showMenuForGameOver:(BOOL)isGameOverMenu
{
    [self.gameTimer invalidate];

    RFMPauseViewController *pauseVC = [[RFMPauseViewController alloc] initWithBackGround: [self screenCapture]
                                                                              isGameOver:isGameOverMenu];
    
    if (isGameOverMenu) {
        // Destroy this viewController before show menu
        self.view = nil;
    }else{
        self.paused = YES;
    }
    [self presentViewController:pauseVC
                       animated:NO
                     completion:nil];
}

-(UIImage *)screenCapture
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenCapture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenCapture;
}

#pragma mark - Powerups
- (void)speedUpBalls:(id)sender {
    self.maxSpeed += 50;
}

- (void)slowDownBalls:(id)sender {
    for (RFMBallView *each in self.playGroundView.subviews) {
        each.speed = each.speed - each.speed/3 * 2;
    }
}
- (void)freezeBalls:(id)sender {
    for (RFMBallView *each in self.playGroundView.subviews) {
        each.speed = 0;
    }
}

- (void)destroyAllBalls:(id)sender {
    self.usedPowerUp = YES;
    for (RFMBallView *each in self.playGroundView.subviews) {
        [self removeBall:each];
    }
    self.usedPowerUp = NO;
}

#pragma mark - delegates
// RFMNewBallTimeBarViewDelegate
-(void)addNewBall
{
    
    if (self.ballBar.canCreateNewBalls) {
        for (int i = 0; i<self.level; i++) {
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
-(void)timeIsUp
{
    self.minRadius = 30;
    self.maxRadius = 60;
    
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

@end
