//
//  RFMGameViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 08/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMGameViewController.h"
#import "RFMBallView.h"

@interface RFMGameViewController ()
@property (nonatomic, strong) NSMutableArray *arrayOfBalls;
@property (nonatomic) BOOL usedPowerUp;
@property (nonatomic) NSInteger minRadius;
@property (nonatomic) NSInteger maxRadius;

//@property (nonatomic) CGFloat maxSpeed;
//@property (nonatomic) CGFloat minSpeed;
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
    
    self.minRadius = 5;
    self.maxRadius = 50;
    
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
                                   selector:@selector(moveBalls:)
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
        [self destroyBallWithFadeOut:each];
    }
    self.usedPowerUp = NO;
}

#pragma mark - Actions
-(void) addBallToView:(id) sender
{
    NSInteger radius = [self randomNumberFrom: 45
                                           To: self.maxRadius];
    
    RFMBallView *ball = [[RFMBallView alloc] initWithposition:[self randomPositionWithRadius:radius]
                                                       radius:radius
                                                  filledColor:[self randomColor]
                                                        speed:[self randomNumberFrom:50
                                                                                  To:150]
                                                    direction:[self randomDirection]];
    [ball setupBall];
    
    // add gesture recognizer
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(didBallTouch:)];
    [oneTap setNumberOfTapsRequired:1];
    [ball addGestureRecognizer:oneTap];
    
    [self.arrayOfBalls addObject:ball];
    [self.playGroundView addSubview:ball];
    
    //self.title = [NSString stringWithFormat:@"%lu", (unsigned long)[self.arrayOfBalls count]];
}

#pragma mark - Operations with balls
-(void) moveBalls:(id) sender
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
            CGFloat nextMovementInX = each.center.x + nextMove * cos(directionInRadiants);
            CGFloat nextMovementInY = each.center.y + nextMove * sin(directionInRadiants);
            
            
            // Check if crash each other
            
            if ([self.arrayOfBalls count] > 1 ) {
                for (RFMBallView *collisionedBall in self.playGroundView.subviews){
                    if (each != collisionedBall) {
                        //calulca la distancia que hay entre los centros de los dos circulos];
                        CGFloat distX = nextMovementInX - collisionedBall.center.x;
                        CGFloat distY = nextMovementInY - collisionedBall.center.y;
                        CGFloat distanceBetweenBalls =sqrt(distX*distX + distY*distY);
                        //si la distancia en el proximo movimiento es menor o igual a la suma de los dos radios es que chocarán
                        if (distanceBetweenBalls <= (collisionedBall.radius + each.radius)) {
                            //Angulo de colision en la bola actual
                            CGFloat collisionAngleBall =(atan2(collisionedBall.center.y - nextMovementInY, collisionedBall.center.x -nextMovementInX) * -180/M_PI);
                            //Angulo de colision en bolaColision
                            CGFloat collisionAngleCollisionedBall =(atan2(nextMovementInY - collisionedBall.center.y, nextMovementInX - collisionedBall.center.x) * -180/M_PI);
                            
                            each.direction = collisionAngleCollisionedBall;
                            collisionedBall.direction = collisionAngleBall;
                            
                            
                           // collisionedBall.radius -= collisionedBall.radius * 0.05;
//                            [self reduceSizeOfCrashedBall:collisionedBall];
                            
                            
                            
                            [self reduceSizeOfCrashedBall:each];
                        }
                        
                    }
                }
                
            }
            

            /*
             
             NSInteger i;
             for (i=0; i<maximo; i++) {
             bola *bolaColision;
             bolaColision = [appDelegate.arrayBolas objectAtIndex:i];
             
             if (self != bolaColision) {
             //calulca la distancia que hay entre los centros de los dos circulos];
             CGFloat distX = proximaPosicion.x-bolaColision.center.x;
             CGFloat distY = proximaPosicion.y-bolaColision.center.y;
             CGFloat distancia =sqrt(distX*distX + distY*distY);
             
             //si la distancia en el proximo movimiento es menor o igual a la suma de los dos radios es que chocarán
             if (distancia <= (bolaColision.radio+self.radio)) {
             //### se multiplica *-180/M_PI para pasar a grados, el signo negativo es para tener el angulo +90 en el cuadrante superior
             //Angulo de colision en la bola actual
             CGFloat anguloChoqueBolaActual =(atan2(bolaColision.center.y-proximaPosicion.y, bolaColision.center.x-proximaPosicion.x)*-180/M_PI);
             //Angulo de colision en bolaColision
             CGFloat anguloChoqueBolaColision =(atan2(proximaPosicion.y-bolaColision.center.y, proximaPosicion.x-bolaColision.center.x)*-180/M_PI);
             
             self.direccion = anguloChoqueBolaColision;
             bolaColision.direccion= anguloChoqueBolaActual;
             
             
             _radio -=_radio*0.05;
             if (_radio<20) {
             _radio=20;
             }
             
             [UIView animateWithDuration:0.1 animations:^{
             [self setFrame:CGRectMake(self.center.x, self.center.y, _radio*2, _radio*2)];
             } completion:^(BOOL finished) {
             [self.layer setCornerRadius:_radio];
             //[etiqueta setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
             }];
             
             bolaColision.haColosionado=YES;
             
             //incrementa la velocidad de cada bola implicada en el choque hasta un maximo de 200pixels/segundo
             if (!_velocidadLimitada && !bolaColision.velocidadLimitada) {
             _velocidad=_velocidad*appDelegate.aumentoVelocidad;
             if (_velocidad>150) {
             _velocidad=150;
             }
             bolaColision.velocidad =bolaColision.velocidad*appDelegate.aumentoVelocidad;
             if (bolaColision.velocidad>150) {
             bolaColision.velocidad =150;
             }
             }
             }
             }
             }
             }
             
             
             */
            
            // Check if ball position is inside the screen bounds
            if (nextMovementInX + each.radius > each.superview.frame.size.width) {
                nextMovementInX = each.superview.frame.size.width - each.radius;
                each.direction = 180 - each.direction;
            }else if (nextMovementInX - each.radius < 0){
                nextMovementInX = each.radius;
                each.direction = (each.direction - 180) * -1;
            }
            
            if (nextMovementInY + each.radius > each.superview.frame.size.height) {
                nextMovementInY = each.superview.frame.size.height - each.radius;
                each.direction *= -1;
            }else if (nextMovementInY - each.radius <0){
                nextMovementInY = each.radius;
                each.direction *=-1;
            }
            
            [each setCenter:CGPointMake(nextMovementInX, nextMovementInY)];
        }
    }
    
}



-(void) reduceSizeOfCrashedBall:(RFMBallView *) aBall
{
    aBall.radius -= aBall.radius * 0.05;
    
    if (aBall.radius < self.minRadius) {
        aBall.radius = self.minRadius;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [aBall setFrame:CGRectMake(aBall.center.x, aBall.center.y, aBall.radius * 2, aBall.radius * 2)];
    } completion:^(BOOL finished) {
        [aBall.layer setCornerRadius:aBall.radius];
    }];
}

-(void) destroyBallWithFadeOut:(id) aBall
{
    RFMBallView *ballToDestroy = aBall;
    [UIView animateWithDuration:.5 animations:^{
        [ballToDestroy setAlpha:0];
        [ballToDestroy setFrame:CGRectMake(ballToDestroy.center.x, ballToDestroy.center.y, 0, 0)];
        [self.arrayOfBalls removeObject: ballToDestroy];
        [self sumPoint:ballToDestroy.radius];
    } completion:^(BOOL finished) {
        [ballToDestroy removeFromSuperview];
    }];
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
    //RFMBallView *tappedBall = sender.view;
    if ([self.arrayOfBalls objectAtIndex:0] == sender.view) {
        [self destroyBallWithFadeOut: sender.view];
    }
         
}

#pragma mark - Utils
-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}
/*
-(NSInteger)randomPositionMinorThan:(NSInteger)maxValue
{
    return (arc4random() % maxValue);
}*/

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

@end
