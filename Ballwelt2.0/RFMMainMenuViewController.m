//
//  RFMMainMenuViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 12/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMMainMenuViewController.h"
#import "RFMGameViewController.h"
#import "RFMBallView.h"
@import Social;

@interface RFMMainMenuViewController ()
@property (nonatomic, strong) NSTimer *moveTimer;
@end

@implementation RFMMainMenuViewController

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
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
    self.moveTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/RATE_PER_SECOND
                                                      target:self
                                                    selector:@selector(moveBall)
                                                    userInfo:nil
                                                     repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.moveTimer invalidate];
    self.moveTimer = nil;
    self.view = nil;
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        [each checkIfInNextMoveReachLimitOfScreen:[each moveBall]];
    }
    
}
#pragma mark - Actions
- (IBAction)startNewGameBtn:(id)sender {

    //self.view = nil;
    RFMGameViewController *newGameVC = [[RFMGameViewController alloc] init];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:newGameVC];
    
    [self presentViewController:navVC
                       animated:NO
                     completion:nil];
}

- (IBAction)socialNetworksBtn:(id)sender {
    UIButton *socialBtn = sender;
    SLComposeViewController *socialVC;
    switch (socialBtn.tag) {
        case 1:
            // Facebook
            socialVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//            [socialVC setInitialText:NSLocalizedString(@"SOCIAL_fb", @"")];
            [socialVC setInitialText:@"Texto para Facebook"];
            break;
        case 2:
            // Twitter
            socialVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//            [socialVC setInitialText:NSLocalizedString(@"SOCIAL_twitter", @"")];
            [socialVC setInitialText:@"texto para Twiteer"];
            break;
        default:
            break;
    }
    [self presentViewController:socialVC animated:YES
                     completion:nil];
}

@end
