//
//  RFMPauseViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 12/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@protocol RFMPauseMenuViewControllerDelegate <NSObject>
-(void)pauseMenuWillRestartGame;
-(void)pauseMenuWillExitGame;
@end

@interface RFMPauseMenuViewController : UIViewController<ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *blurredImage;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UIButton *restartBtn;
@property (weak, nonatomic) IBOutlet UIButton *extiBtn;

@property (weak, nonatomic) IBOutlet UIView *menuSquare;
@property (weak, nonatomic) IBOutlet UIView *scoreSquare;
@property (weak, nonatomic) IBOutlet UILabel *scoreLbl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<RFMPauseMenuViewControllerDelegate> delegate;


-(id)initWithBackGround:(UIImage *) aScreenCapture
             isGameOver:(BOOL) isAGameOver
                  score:(NSInteger) aScore;

-(IBAction)selectedOption:(id)sender;



@end
