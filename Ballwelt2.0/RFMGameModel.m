//
//  RFMGameModel.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 14/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMGameModel.h"

@implementation RFMGameModel

-(id)init
{
    if (self = [super init]) {
        _arrayOfBalls = [[NSMutableArray alloc] init];
        _score = 0;
        _level = 1;
        _minRadius = 35;
        _maxRadius = 50;
        _speedIncrement = 1.2;
        _minSpeed = 70;
        _maxSpeed = 100;
        _reduceRadiusRatio = 1.05;
    }
    return self;
}

-(void)levelUpChangesRadiusAndSpeed
{
    self.level = self.level + 1;
    [self reduceRadius];
    [self incrementSpeed];
}

-(void)reduceRadius
{
    self.maxRadius = self.maxRadius / self.reduceRadiusRatio;
    self.minRadius = self.minRadius / self.reduceRadiusRatio;
    
    if (self.maxRadius <= MIN_RADIUS) {
        self.maxRadius = MIN_RADIUS +1;
    }    
    if (self.minRadius <= MIN_RADIUS) {
        self.minRadius = MIN_RADIUS;
    }
}

-(void)incrementSpeed
{
    self.maxSpeed = self.maxSpeed * self.speedIncrement;
    self.minSpeed = self.minSpeed * self.speedIncrement;
    
    if (self.maxSpeed >= SPEED_LIMIT ) {
        self.maxSpeed = SPEED_LIMIT;
    }
    if (self.minSpeed >= SPEED_LIMIT ) {
        self.minSpeed = SPEED_LIMIT - 1;
    }
}
@end
