//
//  RFMRankingTableViewCell.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 20/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFMRankingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *score;

+(NSString *) playerCellID;
@end
