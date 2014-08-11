//
//  RFMTimeBar.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 11/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFMTimeBar : UIView

@property (nonatomic) NSInteger totalTime;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic, strong) UIColor *barcolor;

-(id) initWithTotalTime:(NSInteger) aTotalTime
                  width:(NSInteger) aWidth
                 height:(NSInteger) aHeight
               barColor:(UIColor *) aBarColor;


@end
