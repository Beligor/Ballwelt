//
//  RFMTimeBar.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 11/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFMTimeBarView : UIView

@property (nonatomic, strong) UIView *timeBar;
@property (nonatomic, strong) UIColor *barcolor;
@property (nonatomic) CGFloat totalTime;
@property (nonatomic) CGFloat timeLeft;
@property (nonatomic) BOOL canCreateNewBalls;
@property (nonatomic) BOOL paused;


-(id) initWithTotalTime:(NSInteger) aTotalTime
                  width:(NSInteger) aWidth
                 height:(NSInteger) aHeight
               position:(CGPoint) aPosition
               barColor:(UIColor *) aBarColor;

-(void)syncrhonizeTimeLeftWithBarWidth;
// Is needed to call this method when is added from IB
-(void)setupBarWithTotalTime:(NSInteger) aTotalTime
                       color:(UIColor *) aColor;
@end
