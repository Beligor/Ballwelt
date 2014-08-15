//
//  RFMAnimatedLabel.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 15/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMAnimatedLabel.h"

@implementation RFMAnimatedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(NSInteger)animateFromThisScore:(NSInteger) initialScore
                          toReach:(NSInteger) finalScore
                   withMultiplier:(NSInteger) multiplier{
    
    if (initialScore < finalScore) {
        initialScore = initialScore + 1 * multiplier;
    }else{
        initialScore = finalScore;
    }
    
    return initialScore;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
