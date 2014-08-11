//
//  RFMGameViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 08/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMGameViewController.h"
#import "RFMBallView.h"
#import "RFMTimeBar.h"

@interface RFMGameViewController ()
@property (nonatomic, strong) NSMutableArray *arrayOfBalls;
@property (nonatomic) BOOL usedPowerUp;
@property (nonatomic) NSInteger minRadius;
@property (nonatomic) NSInteger maxRadius;

@property (nonatomic) CGFloat speedIncrement;
@property (nonatomic) CGFloat maxSpeed;
@property (nonatomic) CGFloat minSpeed;

@end

@implementation RFMGameViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    RFMTimeBar *bar = [[RFMTimeBar alloc] initWithTotalTime:10
                                                      width:self.view.frame.size.width
                                                     height:15
                                                   barColor:[UIColor redColor]];
    
    [self.view addSubview:bar];
    */
    self.minRadius = 20;
    self.maxRadius = 30;
    
    self.speedIncrement = 2;
    self.minSpeed = 100;
    self.maxSpeed = 150;
    
    self.arrayOfBalls = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addBallToView:)];
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
    self.navigationItem.leftBarButtonItems = @[slowButton, freezeButton, destroyButton];
    self.title = [NSString stringWithFormat:@"0"];
    
    // Timer prueba movimiento
    [NSTimer scheduledTimerWithTimeInterval:1.0/RATE_PER_SECOND
                                     target:self
                                   selector:@selector(moveBall)
                                   userInfo:nil
                                    repeats:YES];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Powerups
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

#pragma mark - Actions
-(void) addBallToView:(id) sender
{
    /*
    NSInteger radius = [self randomNumberFrom: self.minRadius
                                           To: self.maxRadius];
    
    
     RFMBallView *ball = [[RFMBallView alloc] initWithposition:[self randomPositionWithRadius:radius]
                                                       radius:radius
                                                  filledColor:[self randomColor]
                                                        speed:[self randomNumberFrom:50
                                                                                  To:150]
                                                    direction:[self randomDirection]];
    */
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

#pragma mark - Operations with balls
-(void) moveBall
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
                        //calulca la distancia que hay entre los centros de los dos circulos];
                        CGFloat distX = nextMoveInX - collisionedBall.center.x;
                        CGFloat distY = nextMoveInY - collisionedBall.center.y;
                        CGFloat distanceBetweenBalls =sqrt(distX*distX + distY*distY);
                        //si la distancia en el proximo movimiento es menor o igual a la suma de los dos radios es que chocarán
                        if (distanceBetweenBalls <= (collisionedBall.radius + each.radius)) {
                            //Angulo de colision en la bola actual
                            CGFloat collisionAngleForBall =(atan2(collisionedBall.center.y - nextMoveInY, collisionedBall.center.x -nextMoveInX) * -180/M_PI);
                            //Angulo de colision en bolaColision
                            CGFloat collisionAngleForCollisionedBall =(atan2(nextMoveInY - collisionedBall.center.y, nextMoveInX - collisionedBall.center.x) * -180/M_PI);
                            
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

-(void) removeBall:(RFMBallView *) aBall
{
    [aBall destroyWithFadeOut];
    [self.arrayOfBalls removeObject: aBall];
    [self sumPoint:aBall.radius];
}

-(void) sumPoint:(NSInteger) points
{
    if (self.usedPowerUp == NO) {
        NSInteger currentScore = [self.title intValue];
        
        currentScore = currentScore + points;
        self.title = [NSString stringWithFormat:@"%ld", (long)currentScore];
    }

}

#pragma mark - Balls Touch Handler
-(void) didBallTouch:(UITapGestureRecognizer *) sender
{
    if ([self.arrayOfBalls objectAtIndex:0] == sender.view) {
        [self removeBall:[self.arrayOfBalls objectAtIndex:0]];
    }
}

/*
#pragma mark - Utils

-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}


-(NSInteger)randomNumberFrom:(NSInteger)minValue To:(NSInteger)maxValue
{
    return (arc4random() % (maxValue - minValue) + minValue);
}
- (NSInteger) randomDirection
{
    return (arc4random()% 360);
}

-(CGPoint)randomPositionWithRadius:(NSInteger) radius
{
    NSInteger x =  arc4random() % (int)self.playGroundView.frame.size.width;
    NSInteger y = arc4random() % (int)self.playGroundView.frame.size.height;

    if (x - radius < 0) {
        x = radius;
    }else if (x + radius >= self.playGroundView.frame.size.width){
        x = self.playGroundView.frame.size.width - radius;
    }
    
    if (y - radius < 0) {
        y = radius;
    }else if (y + radius >= self.playGroundView.frame.size.height){
        y = self.playGroundView.frame.size.height - radius;
    }
    return CGPointMake(x, y);
}
*/
@end
