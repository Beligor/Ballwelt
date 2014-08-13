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
        
            // speed is expressed in points/seconds
            // RATE_PER_SECOND is the N fraction of a second
            // for each fraction of time, we need to know how many points move at this time
            CGFloat nextMove = each.speed/RATE_PER_SECOND;
            
            // To convert degrees in radiants, it has to be multiplied with Pi/180. The -180 is to have 90º in the superior quadrant.
            CGFloat directionInRadiants = each.direction * M_PI/-180;
            
            // Calculates the next position for this time fraction
            CGFloat nextMoveInX = each.center.x + nextMove * cos(directionInRadiants);
            CGFloat nextMoveInY = each.center.y + nextMove * sin(directionInRadiants);
            
        
            // Check if ball position is inside the screen bounds
            if (nextMoveInX + each.radius > each.superview.frame.size.width) {
                nextMoveInX = each.superview.frame.size.width - each.radius;
                each.direction = 180 - each.direction;
            }else if (nextMoveInX - each.radius < 0){
                nextMoveInX = each.radius;
                each.direction = (each.direction - 180) * -1;
            }
            
            if (nextMoveInY + each.radius > each.superview.frame.size.height) {
                nextMoveInY = each.superview.frame.size.height - each.radius;
                each.direction *= -1;
            }else if (nextMoveInY - each.radius <0){
                nextMoveInY = each.radius;
                each.direction *=-1;
            }
            
            
            [each setCenter:CGPointMake(nextMoveInX, nextMoveInY)];
        
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
