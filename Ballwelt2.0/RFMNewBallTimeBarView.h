//
//  RFMNewBallTimeBarView.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 11/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTimeBarView.h"
@class RFMNewBallTimeBarView;

@protocol RFMNewBallTimeBarViewDelegate <NSObject>
-(void)addNewBall;
@end

@interface RFMNewBallTimeBarView : RFMTimeBarView

@property (nonatomic, weak) id<RFMNewBallTimeBarViewDelegate> delegate;

-(void)changeToPauseColor;
-(void)changeToNormalColor;
@end
