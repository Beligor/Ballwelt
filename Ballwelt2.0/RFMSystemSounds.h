//
//  RFMSystemSounds.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 12/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFMSystemSounds : NSObject

+(instancetype) shareSystemSounds;

-(void)correctBall;
-(void)wrongBall;
-(void)menuSelect;
-(void)tutorialPage;
-(void)slowDown;
-(void)freeze;
-(void)destroyAll;
-(void)countdown;
-(void)go;
-(void)startGameOver;
-(void)stopGameOver;
-(void)pause;
-(void)nameForm;
-(void)closeView;

@end
