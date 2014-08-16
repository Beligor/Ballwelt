//
//  RFMAnimatedLabel.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 15/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMAnimatedLabel.h"

@implementation RFMAnimatedLabel

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

@end
