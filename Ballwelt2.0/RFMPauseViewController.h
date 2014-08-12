//
//  RFMPauseViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 12/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFMPauseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backGround;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) BOOL isGameOver;
@property (weak, nonatomic) IBOutlet UIButton *button;

-(id)initWithBackGround:(UIImage *) aScreenCapture
             isGameOver:(BOOL) isGameOver;
- (IBAction)button:(id)sender;


@end
