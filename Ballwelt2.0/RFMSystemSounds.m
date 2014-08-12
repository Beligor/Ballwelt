//
//  RFMSystemSounds.m
//  AngryEsteban
//
//  Created by Rafa Ferrero on 24/07/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMSystemSounds.h"
@import AVFoundation;

#define FOREVER -1

@interface RFMSystemSounds ()
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation RFMSystemSounds

+(instancetype) shareSystemSounds
{
    static RFMSystemSounds *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[RFMSystemSounds alloc] init];
    });
    return shared;
}

-(void) correctBall
{
    [self playFileNamed:@"rightBall"
              extension:@"wav"
          numberOfLoops:0];
}
-(void)wrongBall
{
    [self playFileNamed:@"wrongBall"
              extension:@"wav"
          numberOfLoops:0];
}
/*
-(void) startMachineGun
{
    [self playFileNamed:@"machineGunLoop"
              extension:@"wav"
          numberOfLoops:FOREVER];
}

-(void) stopMachineGun
{
    [self.player stop];
}

-(void) binLaden
{
    [self playFileNamed:@"niQueFueraYoBinLaden"
              extension:@"m4a"
          numberOfLoops:0];
}

-(void) tape
{
    [self playFileNamed:@"tape"
              extension:@"caf"
          numberOfLoops:0];
}

-(void) untape
{
    [self playFileNamed:@"untape"
              extension:@"caf"
          numberOfLoops:0];
}
*/
#pragma mark - Utils
-(void) playFileNamed:(NSString *) name
            extension:(NSString *) extension
        numberOfLoops:(NSInteger) loops
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:name
                                         withExtension:extension];
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                         error:&error];
    if (self.player) {
        // no hubo error
        self.player.numberOfLoops = loops;
        [self.player play];
    }else{
        NSLog(@"Error reading %@: %@",url,error);
    }
}

@end
