//
//  RFMTutorialViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFMTutorialScreenViewController.h"
#import "RFMUserModel.h"

@interface RFMTutorialViewController : UIViewController<UIPageViewControllerDataSource, RFMContentTutorialViewControllerDelegate>
//@property (strong, nonatomic) RFMUserModel *dataUserModel;
//
//-(id)initWithUserDataModel: (RFMUserModel *) aDataUserModel;
@end
