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
@property (nonatomic) CGFloat speed;
@property (nonatomic) NSInteger direction;
@property (nonatomic) BOOL canIncreaseSpeed;
@property (nonatomic) BOOL haveToReduceRadius;

-(id)initWithRandomPositioninViewWithWidth:(NSInteger) aWidth
                                    Height:(NSInteger) anHeight
                                  MinSpeed:(NSInteger) aMinSpeed
                                  maxSpeed:(NSInteger) aMaxSpeed
                                 minRadius:(NSInteger) aMinRadius
                                 maxRadius:(NSInteger) aMaxRadius;


-(CGPoint) moveToNextPoint;
-(void)checkIfInNextMoveReachLimitOfScreen:(CGPoint) nextMove;
-(void) reduceBallSizeUntilReachThisRadius:(NSInteger) minRadius
                             withThisRatio:(CGFloat) ratio;
-(void) increaseSpeedUntilReachThisSpeed:(CGFloat) maxSpeed
                           WithThisRatio:(CGFloat) speedIncrement;
-(void) destroyWithFadeOut;
@end
