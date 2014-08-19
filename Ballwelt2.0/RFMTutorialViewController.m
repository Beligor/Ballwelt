//
//  RFMTutorialViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTutorialViewController.h"
#import "RFMContentTutorialViewController.h"
#import "RFMTutorialCollectionModel.h"

@interface RFMTutorialViewController ()
@property (nonatomic, strong) RFMTutorialCollectionModel *model;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIPageViewController *pageViewController;
@end

@implementation RFMTutorialViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.model = [[RFMTutorialCollectionModel alloc] init];
    
    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                             navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                           options:option];
    [self.pageViewController setDataSource:self];
    
    RFMContentTutorialViewController *initialVC = [self viewControllerAtIndex:0];
    
    NSArray *arrayViewControllers = [NSArray arrayWithObject:initialVC];
    [self.pageViewController setViewControllers:arrayViewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    
    [self.pageViewController.view setFrame: self.view.bounds];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    self.pageControl = [[UIPageControl alloc]init];
    [self.pageControl setCenter: CGPointMake(self.view.center.x, initialVC.view.frame.size.height - 10)];
    [self.pageControl setNumberOfPages: self.model.tutorialScreensCount];
    [self.pageControl setPageIndicatorTintColor:[UIColor blueColor]];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];

    [self.view addSubview:self.pageControl];
}

#pragma mark - Data Source
- (RFMContentTutorialViewController *)viewControllerAtIndex: (NSUInteger) index
{
    if (index > self.model.tutorialScreensCount - 1) {
        return nil;
    }
    return [[RFMContentTutorialViewController alloc]initWithModel: [self.model tutorialScreenAtIndex:index]];
}

- (NSInteger) indexOfViewController:(RFMContentTutorialViewController *) viewController
{
    return [self.model.tutorialScreens indexOfObject:viewController.model];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(RFMContentTutorialViewController *)viewController];
    [self.pageControl setCurrentPage: index];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController: (RFMContentTutorialViewController *)viewController];
    [self.pageControl setCurrentPage:index];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    return [self viewControllerAtIndex:index];
}

@end
