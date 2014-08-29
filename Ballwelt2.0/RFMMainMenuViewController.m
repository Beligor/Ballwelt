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
#import "RFMUserModel.h"
#import "RFMSystemSounds.h"
#import "RFMButtonView.h"

@import Social;

@interface RFMMainMenuViewController ()
@property (nonatomic, strong) NSTimer *moveTimer;
@property (strong, nonatomic) RFMUserModel *userDataModel;
@end

@implementation RFMMainMenuViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: @"backGroundMainMenu.png"]]];
    
    self.userDataModel = [[RFMUserModel alloc] init];
    
    // Set Buttons text
    [self.startGameBtn setTitle: NSLocalizedString(@"MAIN_NewGame", nil)
                       forState: UIControlStateNormal];
    [self.tutorialBtn setTitle: NSLocalizedString(@"MAIN_Tutorial", nil)
                       forState: UIControlStateNormal];
    [self.rankingBtn setTitle: NSLocalizedString(@"MAIN_Ranking", nil)
                       forState: UIControlStateNormal];
    
    [self.startGameBtn customizeAppearance];
    [self.tutorialBtn customizeAppearance];
    [self.rankingBtn customizeAppearance];
    
    // First time request for a nickname and show tutorial
    if ([self.userDataModel.nickname isEqualToString:@""]) {
        UIAlertView *nickInput = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ALERT_title", @"")
                                              message:nil
                                             delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:NSLocalizedString(@"ALERT_OkBtn", nil), nil];
        
        [nickInput setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[RFMSystemSounds shareSystemSounds] nameForm];
        [nickInput show];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Reload model if user has a new record
    if (!self.userDataModel.recordSended) {
        self.userDataModel = [[RFMUserModel alloc] init];
    }
    
    for (int i=0; i<50; i++) {
        [self addBallToView];
    }
    
    // Subscribe to notifications
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
    
    for (RFMBallView *each in self.ballsBackgroundView.subviews) {
        [each removeFromSuperview];
    }
    // Unsubscribe of notifications
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
    [[RFMSystemSounds shareSystemSounds] menuSelect];
    UIButton *btn = sender;
    UIViewController *VC = nil;
    switch (btn.tag) {
        case 0:
            VC = [[RFMGameViewController alloc] initWithUserDataModel:self.userDataModel];
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
            VC = [[RFMRankingViewController alloc] initWithUserDataModel:self.userDataModel];
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

#pragma mark - Nickname Alert View
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    
    NSString *text = [[alertView textFieldAtIndex:0] text];
    NSCharacterSet *noSpacing = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range = [text rangeOfCharacterFromSet:noSpacing];
    
    //comprueba que el texto no supere el tamaño maximo permitido, no este en blanco y no haya espacios en blanco
    if ([text length] <= 15 && ![text isEqualToString:@""] && (range.location == NSNotFound)) {
        return YES;
    }else{
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[RFMSystemSounds shareSystemSounds] pause];
    int numberID =  arc4random() % 999999999999999999; // Random number and name makes unique ID
    
    NSString *ID = [NSString stringWithFormat:@"%@%i", [[alertView textFieldAtIndex:0] text], numberID];
    
    self.userDataModel.ID = ID;
    self.userDataModel.nickname = [[alertView textFieldAtIndex:0] text];
    
    // Save changes in Plist
    [self.userDataModel saveData];
    
    // Show Tutorial
    RFMTutorialViewController *VC = [[RFMTutorialViewController alloc] init];
    [self presentViewController:VC
                       animated:YES
                     completion:nil];
}
@end
