//
//  RFMNewBallTimeBarView.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 11/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMNewBallTimeBarView.h"

@implementation RFMNewBallTimeBarView


-(void)timeOver{
    self.timeLeft = self.totalTime;
    [self.delegate timerBarWilladdNewBall];
}

-(void)changeToPauseColor
{
    self.timeBar.backgroundColor = Rgb2UIColor(84, 103, 220);
}
-(void)changeToNormalColor
{
    self.timeBar.backgroundColor = self.barcolor;
}

@end
