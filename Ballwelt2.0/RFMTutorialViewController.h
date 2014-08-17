//
//  RFMTutorialViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFMContentTutorialViewController.h"
@interface RFMTutorialViewController : UIViewController<UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *arrayTitulos;
@property (nonatomic, strong) NSMutableArray *arrayTextos;

@end
