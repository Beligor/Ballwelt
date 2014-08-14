//
//  RFMGameTimeBarView.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 11/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTimeBarView.h"
@class RFMGameTimeBarView;

@protocol RFMGameTimeBarViewDelegate <NSObject>
-(void)timerBarWillEndGame;
@end

@interface RFMGameTimeBarView : RFMTimeBarView
@property (nonatomic, weak) id<RFMGameTimeBarViewDelegate> delegate;

-(void) addExtraTime;
@end
