//
//  RFMTutorialViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTutorialViewController.h"
#import "RFMTutorialScreenViewController.h"
#import "RFMTutorialModel.h"
#import "RFMSystemSounds.h"
@interface RFMTutorialViewController ()
@property (nonatomic, strong) RFMTutorialModel *model;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIPageViewController *pageViewController;
@end

@implementation RFMTutorialViewController

//#pragma mark - Init
//-(id)initWithUserDataModel: (RFMUserModel *) aDataUserModel
//{
//    if (self = [super init]) {
//        _dataUserModel = aDataUserModel;
//    }
//    return self;
//}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];   
    
    self.model = [[RFMTutorialModel alloc] init];
    
    // Configure Page View Controller
    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                             navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                           options:option];
    [self.pageViewController setDataSource:self];
    
    // Set first VC to show
    RFMTutorialScreenViewController *initialVC = [self viewControllerAtIndex:0];
    
    NSArray *arrayViewControllers = [NSArray arrayWithObject:initialVC];
    
    [self.pageViewController setViewControllers:arrayViewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];

    [self.view addSubview:self.pageViewController.view];
    
    
    // Configure page control dots aspect
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.Center = CGPointMake(self.view.center.x, initialVC.view.frame.size.height - 10);
    self.pageControl.NumberOfPages = self.model.tutorialScreensCount;
    [self.pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    [self.pageControl setCurrentPageIndicatorTintColor:Rgb2UIColor(69, 24, 46)];

    [self.view addSubview:self.pageControl];
}



#pragma mark - Data Source
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    [[RFMSystemSounds shareSystemSounds] tutorialPage];
    NSUInteger index = [self indexOfViewController:(RFMTutorialScreenViewController *)viewController];
    
    self.pageControl.CurrentPage = index;
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    [[RFMSystemSounds shareSystemSounds] tutorialPage];
    NSUInteger index = [self indexOfViewController: (RFMTutorialScreenViewController *)viewController];
    
    self.pageControl.CurrentPage= index;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    return [self viewControllerAtIndex:index];
}

#pragma mark - Utils
- (RFMTutorialScreenViewController *)viewControllerAtIndex: (NSUInteger) index
{
    if (index > self.model.tutorialScreensCount - 1) {
        return nil;
    }
    RFMTutorialScreenViewController *VC = nil;

    if (index == self.model.tutorialScreensCount - 1) {
        VC = [[RFMTutorialScreenViewController alloc]initWithModel:[self.model tutorialScreenAtIndex:index]
                                                        showButton:YES];
        VC.delegate = self;
    }else{
        VC = [[RFMTutorialScreenViewController alloc]initWithModel:[self.model tutorialScreenAtIndex:index]
                                                        showButton:NO];
    }    
    return VC;
}

- (NSInteger) indexOfViewController:(RFMTutorialScreenViewController *) viewController
{
    return [self.model.tutorialScreens indexOfObject:viewController.model];
}

#pragma mark - Delegate
// RFMContentTutorialViewController.h
-(void)willCloseTutorial
{
    [[RFMSystemSounds shareSystemSounds] closeView];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
@end
