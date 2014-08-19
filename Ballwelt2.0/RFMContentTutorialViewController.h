//
//  RFMContentTutorialViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RFMTutorialModel;

@interface RFMContentTutorialViewController : UIViewController

@property (strong, nonatomic) RFMTutorialModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;

-(id) initWithModel:(RFMTutorialModel *) aModel;

@end
