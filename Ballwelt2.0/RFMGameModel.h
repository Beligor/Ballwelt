//
//  RFMGameModel.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 14/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFMGameModel : NSObject

@property (nonatomic, strong) NSMutableArray *arrayOfBalls;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger minRadius;
@property (nonatomic) NSInteger maxRadius;
@property (nonatomic) CGFloat speedIncrement;
@property (nonatomic) CGFloat maxSpeed;
@property (nonatomic) CGFloat minSpeed;
@property (nonatomic) CGFloat reduceRadiusRatio;

-(void)levelUpChangesRadiusAndSpeed;
@end
