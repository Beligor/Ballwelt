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
        _minRadius = 10;
        _maxRadius = 50;
        _speedIncrement = 1.2;
        _minSpeed = 70;
        _maxSpeed = 100;
        _numberOfGameOverBalls = 0;
    }
    return self;
}
@end
