//
//  RFMRankingViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 19/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface RFMRankingViewController : UIViewController<UITableViewDataSource, ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *rankingTitle;
@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)closeRanking:(id)sender;
@end
