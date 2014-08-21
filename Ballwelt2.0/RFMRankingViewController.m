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

@interface RFMRankingViewController ()
@property (strong, nonatomic) RFMRanking *model;
@end

@implementation RFMRankingViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundPlayScreen"]];
    self.rankingTitle.text = NSLocalizedString(@"RANKING_Title", nil);
    [self.table setBackgroundColor: [UIColor clearColor]];
    self.model = [[RFMRanking alloc] init];
    [self registerPlayerCell];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];      
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
    RFMPlayerModel *player = [self.model playerAtIndex:indexPath.row];
  
    
    
    RFMRankingTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:[RFMRankingTableViewCell playerCellID]];

    playerCell.position.text = [NSString stringWithFormat:@"%li",indexPath.row + 1];
    playerCell.name.text = player.name;
    playerCell.score.text = player.score;
    
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
