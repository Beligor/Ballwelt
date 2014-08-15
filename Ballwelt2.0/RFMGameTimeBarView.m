//
//  RFMGameTimeBarView.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 11/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMGameTimeBarView.h"

@implementation RFMGameTimeBarView

-(void)timeOver
{
    [self.delegate timerBarWillEndGame];
}

-(void) addExtraTime
{
    self.timeLeft = self.timeLeft + 1;
    if (self.timeLeft >= self.totalTime) {
        self.timeLeft = self.totalTime;
    }
}
@end
