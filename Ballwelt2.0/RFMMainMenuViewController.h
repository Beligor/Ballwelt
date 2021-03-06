//
//  RFMMainMenuViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 12/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RFMButtonView;

@interface RFMMainMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *ballsBackgroundView;
@property (weak, nonatomic) IBOutlet RFMButtonView *startGameBtn;
@property (weak, nonatomic) IBOutlet RFMButtonView *tutorialBtn;
@property (weak, nonatomic) IBOutlet RFMButtonView *rankingBtn;

- (IBAction)chooseAnOption:(id)sender;
- (IBAction)socialNetworksBtn:(id)sender;

@end
