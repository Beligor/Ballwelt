//
//  RFMContentTutorialViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RFMTutorialScreenModel;
@class RFMButtonView;

@protocol RFMContentTutorialViewControllerDelegate <NSObject>
-(void) willCloseTutorial;
@end

@interface RFMTutorialScreenViewController : UIViewController

@property (strong, nonatomic) RFMTutorialScreenModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet RFMButtonView *closeButton;

@property (nonatomic) BOOL showButton;

@property (weak, nonatomic) id<RFMContentTutorialViewControllerDelegate> delegate;

-(id) initWithModel:(RFMTutorialScreenModel *) aModel
         showButton:(BOOL) showButton;
- (IBAction)closeTutorial:(id)sender;


@end
