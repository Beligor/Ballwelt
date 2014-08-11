//
//  RFMBall.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 08/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMBallView.h"

@implementation RFMBallView


#pragma mark - Init
-(id)initWithposition:(CGPoint)aPosition
               radius:(NSInteger) aRadius
          filledColor:(UIColor *) aColor
                speed:(CGFloat) aSpeed
            direction:(NSInteger) aDirection
{
    if (self = [super initWithFrame:CGRectMake(0, 0, aRadius * 2, aRadius * 2)])
    {
        _position = aPosition;
        _radius = aRadius;
        _color = aColor;
        _speed = aSpeed;
        _direction = aDirection;
        [self setupBall];
    }
    return self;
}

-(id)initWithRandomPositioninViewWithWidth:(NSInteger) aWidth
                                    Height:(NSInteger) anHeight
                                  MinSpeed:(NSInteger) aMinSpeed
                                  maxSpeed:(NSInteger) aMaxSpeed
                                 minRadius:(NSInteger) aMinRadius
                                 maxRadius:(NSInteger) aMaxRadius
{
    _radius= [self randomNumberFrom:aMinRadius
                        To:aMaxRadius];
    if (self = [super initWithFrame:CGRectMake(0, 0, _radius * 2, _radius * 2)]) {
        _position = [self randomPositionInViewWithWidht:aWidth
                                              andHeight:anHeight];
        _color = [self randomColor];
        _speed = [self randomNumberFrom:aMinSpeed
                                     To:aMaxSpeed];
        _direction = [self randomDirection];
        [self setupBall];
    }
    return self;
}


#pragma mark - View Lifecycle
-(void)dealloc
{
    NSLog(@"destruida");
}


#pragma mark - Setup Ball
-(void) setupBall
{
    self.backgroundColor = self.color;
    self.layer.cornerRadius = self.radius;
    [self.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.layer setBorderWidth:2.0];
    
    self.center = self.position;
}

#pragma mark - Actions

-(void) increaseSpeedWithThisIncrement:(CGFloat) speedIncrement
                                 until:(CGFloat) maxSpeed
{
    CGFloat newSpeed;
    newSpeed = self.speed * speedIncrement;
    
    if (newSpeed > maxSpeed) {
        self.speed = maxSpeed;
    }else{
        self.speed = newSpeed;
    }
}

-(void) reducesBallSizeUntilReachThisRadius:(NSInteger) minRadius
{
    self.radius -= self.radius * 0.05;
    
    if (self.radius < minRadius) {
        self.radius = minRadius;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [self setFrame:CGRectMake(self.center.x, self.center.y, self.radius * 2, self.radius * 2)];
    } completion:^(BOOL finished) {
        [self.layer setCornerRadius:self.radius];
    }];
}

-(void) destroyWithFadeOut
{
    [UIView animateWithDuration:.5 animations:^{
        [self setAlpha:0];
        [self setFrame:CGRectMake(self.center.x, self.center.y, 0, 0)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Utils
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: Posicion X: %li Posicion Y: %li Radio: %ld Velocidad: %ld Dirección: %ld",[self class],(long)self.position.x, (long)self.position.y , (long)self.radius, (long)self.speed, (long)self.direction];
}

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

-(CGPoint)randomPositionInViewWithWidht:(NSInteger) width
                              andHeight:(NSInteger) height
{
    NSInteger x =  arc4random() % width;
    NSInteger y = arc4random() % height;
    
    if (x - self.radius < 0) {
        x = self.radius;
    }else if (x + self.radius >= width){
        x = width - self.radius;
    }
    
    if (y - self.radius < 0) {
        y = self.radius;
    }else if (y + self.radius >= height){
        y = height - self.radius;
    }
    return CGPointMake(x, y);
}

@end
