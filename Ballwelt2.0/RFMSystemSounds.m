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

+(NSString *)popBallSound
{
    NSArray *sounds = @[@"pop1", @"pop2", @"pop3", @"pop4", @"pop5", @"pop6", @"pop7", @"pop8", @"pop9"];
    return [sounds objectAtIndex:arc4random()% [sounds count]];
}

-(void)menuSelect
{
    [self playFileNamed:@"menuSelection"
              extension:@"wav"
          numberOfLoops:0];
}

-(void)countdown
{
    [self playFileNamed:@"countdown2"
              extension:@"wav"
          numberOfLoops:0];
}

-(void)go
{
    [self playFileNamed:@"go"
              extension:@"wav"
          numberOfLoops:0];
}

-(void)correctBall
{
    [self playFileNamed: [RFMSystemSounds popBallSound]
              extension:@"wav"
          numberOfLoops:0];
}

-(void)wrongBall
{
    [self playFileNamed:@"wrongBall"
              extension:@"wav"
          numberOfLoops:0];
}

-(void)slowDown
{
    [self playFileNamed:@"slow"
              extension:@"wav"
          numberOfLoops:0];
}

-(void)freeze
{
    [self playFileNamed:@"freeze"
              extension:@"wav"
          numberOfLoops:0];
}

-(void)destroyAll
{
    [self playFileNamed:@"destroyAllBalls"
              extension:@"wav"
          numberOfLoops:0];
}

-(void)pause
{
    [self playFileNamed:@"pause"
              extension:@"wav"
          numberOfLoops:0];
}

-(void)startGameOver
{
    [self playFileNamed:@"gameover"
              extension:@"mp3"
          numberOfLoops:FOREVER];
}

-(void)stopGameOver
{
    [self.player stop];
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
        // No error
        self.player.numberOfLoops = loops;
        [self.player play];
    }else{
        NSLog(@"Error reading %@: %@",url,error);
    }
}

@end
