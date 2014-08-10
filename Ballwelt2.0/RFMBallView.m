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


#pragma mark - Utils
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: Posicion X: %li Posicion Y: %li Radio: %ld Velocidad: %ld Dirección: %ld",[self class],(long)self.position.x, (long)self.position.y , (long)self.radius, (long)self.speed, (long)self.direction];
}

@end
