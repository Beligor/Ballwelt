//
//  RFMPowerupBallView.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 15/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RFMPowerupViewDelegate <NSObject>

-(void)powerUpDidUsed;

@end

@interface RFMPowerupView : UIView
@property (nonatomic) NSInteger powerupNumber;
@property (nonatomic, weak) id<RFMPowerupViewDelegate> delegate;

-(id)initWithRadius:(NSInteger) aRadius;
-(void) setupPowerup;
-(void)increaseFillsCircle;
-(void)breakStreak;
- (void) blink;
@end
