//
//  RFMRankingViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 19/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@class RFMUserModel;
@class RFMButtonView;

@interface RFMRankingViewController : UIViewController<UITableViewDataSource, ADBannerViewDelegate>
@property (strong, nonatomic) RFMUserModel *userDataModel;
@property (weak, nonatomic) IBOutlet UILabel *rankingTitle;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet RFMButtonView *backButton;

@property (weak, nonatomic) IBOutlet UIView *outOfRankingView;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *score;

-(id)initWithUserDataModel:(RFMUserModel *) anUserDataModel;
- (IBAction)closeRanking:(id)sender;
@end
