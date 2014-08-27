//
//  RFMSystemSounds.h
//  AngryEsteban
//
//  Created by Rafa Ferrero on 24/07/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFMSystemSounds : NSObject

+(instancetype) shareSystemSounds;

-(void)correctBall;
-(void)wrongBall;
-(void)menuSelect;
-(void)slowDown;
-(void)freeze;
-(void)destroyAll;
-(void)countdown;
-(void)go;
-(void)startGameOver;
-(void)stopGameOver;
-(void)pause;
/*
-(void) startMachineGun;
-(void) stopMachineGun;
-(void) binLaden;
-(void) tape;
-(void) untape;
*/

@end
