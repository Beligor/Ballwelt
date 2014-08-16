//
//  RFMPowerupBallView.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 15/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RFMPowerupBallViewDelegate <NSObject>

-(void)powerUpDidUsed;

@end

@interface RFMPowerupBallView : UIView
@property (nonatomic) NSInteger powerupNumber;
@property (nonatomic, weak) id<RFMPowerupBallViewDelegate> delegate;

-(id)initWithRadius:(NSInteger) aRadius;
-(void) setupPowerup;
-(void)increaseFillsCircle;
-(void)restartPowerUp;
- (void) blink;
@end
