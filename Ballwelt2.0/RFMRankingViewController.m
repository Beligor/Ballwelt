//
//  RFMRankingViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 19/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMRankingViewController.h"
#import "RFMRanking.h"
#import "RFMPlayerModel.h"
#import "RFMRankingTableViewCell.h"
#import "RFMUserModel.h"

@interface RFMRankingViewController ()
@property (strong, nonatomic) RFMRanking *model;
@end

@implementation RFMRankingViewController

#pragma mark - Init
-(id)initWithUserDataModel:(RFMUserModel *) anUserDataModel
{
    if (self = [super init]) {
        _userDataModel = anUserDataModel;
    }
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rankingTitle.text = NSLocalizedString(@"RANKING_Title", nil);
    [self.table setBackgroundColor: [UIColor clearColor]];
    [self registerPlayerCell];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.activityIndicator startAnimating];
    [self connectToServer];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.activityIndicator stopAnimating];
}

#pragma mark - Get Online Ranking
-(void)connectToServer
{
    // Get queue
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(backgroundQueue, ^{
        // Check in background if server is up
        NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://macuversium.mooo.com/www/Ballwelt/Ballwelt_checkServer.html"]
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
        if (connect) {
            [self sendHighScoreToServer];
            [self getDataFromServer];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (connect) {
                [self.table reloadData];
            }else{
                self.table.hidden = YES;
                [self showErrorMessage];
                [self showLocalRecord];
            }
            [self.activityIndicator stopAnimating];
        });
    });
}

-(void)sendHighScoreToServer
{
    if (!self.userDataModel.recordSended) {

        // Delete forbidden characters of nickname
        NSString *nickname = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self.userDataModel.nickname, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));

        // Execute PHP sentence
        NSURL *URL = [NSURL URLWithString: [NSString stringWithFormat:@"http://macuversium.mooo.com/www/BallweltGuardaPuntuacion?nick=%@&pnt=%ld&dt=%@&id=%@", nickname, (long)self.userDataModel.highScore, self.userDataModel.date, self.userDataModel.ID]];
        
        NSData *dataURL = [NSData dataWithContentsOfURL:URL];
        
        // Get the result
        NSString *resultado = [[NSString alloc]initWithData:dataURL
                                                   encoding:NSUTF8StringEncoding];
        
        if ([resultado isEqualToString:@"envio OK"]) {
            self.userDataModel.recordSended = YES;
            [self.userDataModel saveData];
        }
    }
}

-(void)getDataFromServer
{
    self.model = [[RFMRanking alloc] init];
    if (![self checkIfPlayerIsInTop10]){
        [self showLocalRecord];
    }
}

-(BOOL)checkIfPlayerIsInTop10
{
    for (RFMPlayerModel *each in self.model.playersList) {
        if ([each.ID isEqualToString: self.userDataModel.ID]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Utils
-(void)registerPlayerCell
{
    // Read nib file
    UINib *nib = [UINib nibWithNibName:@"RFMRankingTableViewCell"
                                bundle:nil];
    // Register it
    [self.table registerNib:nib
         forCellReuseIdentifier: [RFMRankingTableViewCell playerCellID]];
}

-(void)showLocalRecord
{
    self.outOfRankingLabel.hidden = NO;
    self.outOfRankingLabel.text = [NSString stringWithFormat:@"%@ - %li", self.userDataModel.nickname, (long)self.userDataModel.highScore];
}

-(void)showErrorMessage
{
    self.rankingTitle.hidden = YES;
    self.errorLabel.hidden = NO;
    self.errorLabel.text = NSLocalizedString(@"RANKING_Notice", nil);
}

#pragma mark - Table Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [self.model playersCount];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RFMPlayerModel *player = [self.model playerInPosition:indexPath.row];
    
    RFMRankingTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:[RFMRankingTableViewCell playerCellID]];

    playerCell.position.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    playerCell.name.text = player.name;
    playerCell.score.text = player.score;
    
    if ([player.ID isEqualToString:self.userDataModel.ID]) {
        playerCell.backgroundColor = Rgb2UIColor(94, 80, 87);

    }else{
        playerCell.backgroundColor = [UIColor clearColor];
    }
    
    return playerCell;
}

#pragma mark - Actions
- (IBAction)closeRanking:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - iAd Delegate Methods
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}

- (void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}

@end
