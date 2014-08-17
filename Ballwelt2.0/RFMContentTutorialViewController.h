//
//  RFMContentTutorialViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFMContentTutorialViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleString;
@property (weak, nonatomic) IBOutlet UILabel *textString;
@property (strong, nonatomic) id dataObject1;
@property (strong, nonatomic) id dataObject2;

@end
