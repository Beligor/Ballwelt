//
//  RFMAnimatedLabel.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 15/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFMAnimatedLabel : UILabel


-(NSInteger)animateFromThisScore:(NSInteger) initialScore
                         toReach:(NSInteger) finalScore
                  withMultiplier:(NSInteger) multiplier;
@end
