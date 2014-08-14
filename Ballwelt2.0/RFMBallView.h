//
//  RFMBall.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 08/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFMBallView : UIView

@property (nonatomic) CGPoint position;
@property (nonatomic) NSInteger radius;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) CGFloat speed;
@property (nonatomic) NSInteger direction;
@property (nonatomic) BOOL canIncreaseSpeed;

-(id)initWithRandomPositioninViewWithWidth:(NSInteger) aWidth
                                    Height:(NSInteger) anHeight
                                  MinSpeed:(NSInteger) aMinSpeed
                                  maxSpeed:(NSInteger) aMaxSpeed
                                 minRadius:(NSInteger) aMinRadius
                                 maxRadius:(NSInteger) aMaxRadius;


-(CGPoint) moveBall;
-(void)checkIfInNextMoveReachLimitOfScreen:(CGPoint) nextMove;

-(void) reducesBallSizeUntilReachThisRadius:(NSInteger) minRadius;
-(void) increaseSpeedWithThisIncrement:(CGFloat) speedIncrement
                                 until:(CGFloat) maxSpeed;
-(void) destroyWithFadeOut;
@end
