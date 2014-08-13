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
#import "RFMPauseViewController.h"

@interface RFMGameViewController : UIViewController<RFMNewBallTimeBarViewDelegate, RFMGameTimeBarViewDelegate, RFMPauseViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *playGroundView;
@property (weak, nonatomic) IBOutlet UIView *controlPanelView;
@property (nonatomic) BOOL paused;

-(void)setUpTimer;
@end
