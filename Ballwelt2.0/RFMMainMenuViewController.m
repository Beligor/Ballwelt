//
//  RFMMainMenuViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 12/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMMainMenuViewController.h"
#import "RFMBallView.h"
#import "RFMGameViewController.h"
#import "RFMTutorialViewController.h"
#import "RFMRankingViewController.h"

@import Social;

@interface RFMMainMenuViewController ()
@property (nonatomic, strong) NSTimer *moveTimer;
@end

@implementation RFMMainMenuViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (int i=0; i<50; i++) {
        [self addBallToView];
    }
    
    // Alta en notificaciones
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDelegateNotifies:)
                                                 name:@"pauseGame"
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![self.moveTimer isValid]) {
        [self startTimer];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
    self.view = nil;
    
    // Baja en notificaciones
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications
-(void)appDelegateNotifies:(NSNotification *)aNotification
{
    if ([self.moveTimer isValid]) {
        [self stopTimer];
    }else{
        [self startTimer];
    }
}


#pragma mark - Timer Utils
-(void)startTimer
{
    self.moveTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/RATE_PER_SECOND
                                                      target:self
                                                    selector:@selector(moveBall)
                                                    userInfo:nil
                                                     repeats:YES];
}

-(void)stopTimer
{
    [self.moveTimer invalidate];
    self.moveTimer = nil;
}

#pragma mark - Balls Control
-(void)addBallToView
{
    
    RFMBallView *ball = [[RFMBallView alloc] initWithRandomPositioninViewWithWidth:self.ballsBackgroundView.frame.size.width
                                                                            Height:self.ballsBackgroundView.frame.size.height
                                                                          MinSpeed:50
                                                                          maxSpeed:150
                                                                         minRadius:10
                                                                         maxRadius:40];
    [self.ballsBackgroundView addSubview:ball];
}

-(void)moveBall
{
    for (RFMBallView *each in self.ballsBackgroundView.subviews) {
        
        [each checkIfInNextMoveReachLimitOfScreen:[each moveToNextPoint]];
    }
    
}

#pragma mark - Actions
-(void)chooseAnOption:(id)sender
{
    UIButton *btn = sender;
    UIViewController *VC = nil;
    switch (btn.tag) {
        case 0:
            VC = [[RFMGameViewController alloc] init];
            [self.navigationController pushViewController:VC
                                                 animated:NO];
            break;
        case 1:
            VC = [[RFMTutorialViewController alloc] init];
            [self presentViewController:VC
                               animated:YES
                             completion:nil];
            break;
        case 2:
            VC = [[RFMRankingViewController alloc] init];
            [self.navigationController pushViewController:VC
                                                 animated:YES];
            break;
        default:
            break;
    }
}

- (IBAction)socialNetworksBtn:(id)sender {
    UIButton *socialBtn = sender;
    SLComposeViewController *socialVC;
    switch (socialBtn.tag) {
        case 1:
            // Facebook
            socialVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [socialVC setInitialText:NSLocalizedString(@"SOCIAL_fb", @"")];
            break;
        case 2:
            // Twitter
            socialVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [socialVC setInitialText:NSLocalizedString(@"SOCIAL_twitter", @"")];
            break;
        default:
            break;
    }
    [self presentViewController:socialVC animated:YES
                     completion:nil];
}

@end
