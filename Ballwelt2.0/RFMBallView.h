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


-(id)initWithposition:(CGPoint)aPosition
               radius:(NSInteger) aRadius
          filledColor:(UIColor *) aColor
                speed:(CGFloat) aSpeed
            direction:(NSInteger) aDirection;

-(void) setupBall;
@end
