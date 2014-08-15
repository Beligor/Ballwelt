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
#import "RFMAnimatedLabel.h"
#import "RFMPauseMenuViewController.h"

@interface RFMGameViewController : UIViewController<RFMNewBallTimeBarViewDelegate, RFMGameTimeBarViewDelegate, RFMPauseMenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *playGroundView;
@property (weak, nonatomic) IBOutlet UIView *controlPanelView;
@property (weak, nonatomic) IBOutlet RFMGameTimeBarView *gameTimeBar;
@property (weak, nonatomic) IBOutlet RFMNewBallTimeBarView *ballTimeBar;
@property (weak, nonatomic) IBOutlet RFMAnimatedLabel *scoreAnimatedLabel;



@property (nonatomic) BOOL paused;

-(void)setUpTimer;
@end
