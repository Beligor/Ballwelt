//
//  RFMTimeBar.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 11/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTimeBar.h"

@implementation RFMTimeBar

-(id) initWithTotalTime:(NSInteger) aTotalTime
                  width:(NSInteger) aWidth
                 height:(NSInteger) aHeight
               barColor:(UIColor *) aBarColor
{
    if (self = [super initWithFrame:CGRectMake(0, 150, aWidth, aHeight)]) {
        _totalTime = aTotalTime;
        _barcolor = aBarColor;
        self.backgroundColor = aBarColor;
        [self.layer setBorderColor:[[UIColor blackColor]CGColor]];
        [self.layer setBorderWidth:1];
        [self.layer setCornerRadius:aHeight/2]; //redondea los extremos
    }
    return self;
}

-(void) setUpSubViews
{
    
}/*

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        _totalTime = [aDecoder decodeObjectForKey:@"totalTime"];
        
        // similarly for other instance variables
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:enCoder];
    
    [enCoder encodeObject:instanceVariable forKey:INSTANCEVARIABLE_KEY];
}*/
@end
