//
//  RFMTimeBar.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 11/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFMTimeBarView : UIView

@property (nonatomic) CGFloat totalTime;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic) CGPoint position;
@property (nonatomic, strong) UIColor *barcolor;

@property (nonatomic) CGFloat timeLeft;
@property (nonatomic, strong) UIView *timeBar;
@property (nonatomic) BOOL canCreateNewBalls;
@property (nonatomic) BOOL paused;


-(id) initWithTotalTime:(NSInteger) aTotalTime
                  width:(NSInteger) aWidth
                 height:(NSInteger) aHeight
               position:(CGPoint) aPosition
               barColor:(UIColor *) aBarColor;

-(void)syncrhonizeTimeLeftWithBarWidth;

@end
