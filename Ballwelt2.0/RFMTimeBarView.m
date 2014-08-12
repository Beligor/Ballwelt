//
//  RFMTimeBar.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 11/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTimeBarView.h"
@interface RFMTimeBarView()

@property (nonatomic) CGFloat timeFraction;


@end

@implementation RFMTimeBarView

#pragma mark - Init
-(id) initWithTotalTime:(NSInteger) aTotalTime
                  width:(NSInteger) aWidth
                 height:(NSInteger) aHeight
               position:(CGPoint) aPosition
               barColor:(UIColor *) aBarColor
{
    if (self = [super initWithFrame:CGRectMake(aPosition.x, aPosition.y, aWidth, aHeight)]) {
        _totalTime = aTotalTime;
        _barcolor = aBarColor;
        _timeLeft = aTotalTime;
        _timeFraction = 1/(float)RATE_PER_SECOND;
        _canCreateNewBalls = YES;
        _paused = NO;
        [self setUpTimeBar];
    }
    return self;
}

#pragma mark - Setup
-(void)setUpTimeBar
{
    self.backgroundColor = [UIColor clearColor];
    [self.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.layer setBorderWidth:2];
    
    self.timeBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.timeBar.backgroundColor = self.barcolor;
    
    [self addSubview:self.timeBar];
}

#pragma mark - Draw Bar
-(void)syncrhonizeTimeLeftWithBarWidth
{
    
        if (self.timeLeft > 0) {
            CGFloat newBarLength= self.timeLeft * (self.frame.size.width/self.totalTime);
            [self.timeBar setFrame:CGRectMake(0, 0, newBarLength, self.timeBar.frame.size.height)];
            [self roundCorners];
            
            if (self.paused == NO) {
                self.timeLeft = self.timeLeft - self.timeFraction;
            }
            
        }else{
            [self timeOver];
    }

}

- (void) roundCorners
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.timeBar.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(self.frame.size.height / 2, self.frame.size.height / 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.timeBar.layer.mask = maskLayer;
}

-(void)timeOver{
    // Write this method in subclass
}

@end
