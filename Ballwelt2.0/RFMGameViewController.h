//
//  RFMGameViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 08/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFMNewBallTimeBarView.h"
#import "RFMGameTimeBarView.h"
#import "RFMPauseMenuViewController.h"
#import "RFMAnimatedLabel.h"
#import "RFMPowerupView.h"
@class RFMUserModel;

@interface RFMGameViewController : UIViewController<RFMNewBallTimeBarViewDelegate, RFMGameTimeBarViewDelegate, RFMPauseMenuViewControllerDelegate, RFMPowerupViewDelegate>


@property (strong, nonatomic) RFMUserModel *userDataModel;
@property (weak, nonatomic) IBOutlet UIView *playGroundView;
@property (weak, nonatomic) IBOutlet UIView *controlPanelView;
@property (weak, nonatomic) IBOutlet RFMGameTimeBarView *gameTimeBar;
@property (weak, nonatomic) IBOutlet RFMNewBallTimeBarView *ballTimeBar;
@property (weak, nonatomic) IBOutlet RFMAnimatedLabel *scoreAnimatedLabel;
@property (weak, nonatomic) IBOutlet RFMPowerupView *powerUpView;
@property (weak, nonatomic) IBOutlet UIView *countdownSquare;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

-(id)initWithUserDataModel:(RFMUserModel *) anUserDataModel;
@end
