//
//  RFMTutorialViewController.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTutorialViewController.h"
#import "RFMContentTutorialViewController.h"

@interface RFMTutorialViewController ()

@end

@implementation RFMTutorialViewController{
UIPageControl *pageControl;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrayTitulos = [[NSMutableArray alloc]init];
    for (int i =0; i<6; i++) {
        [_arrayTitulos addObject:[NSString stringWithFormat:@"Página %d", i+1]];
    }
    _arrayTextos= [[NSMutableArray alloc]init];
    for (int i =0; i<6; i++) {
        [_arrayTextos addObject:[NSString stringWithFormat:@"Esto es el texto para la página %d", i+1]];
    }
    
    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
    [_pageViewController setDataSource:self];
    
    RFMContentTutorialViewController *initialVC = [self viewControllerAtIndex:0];
    
    NSArray *arrayViewControllers = [NSArray arrayWithObject:initialVC];
    [_pageViewController setViewControllers:arrayViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [_pageViewController.view setFrame:self.view.bounds];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    
    pageControl = [[UIPageControl alloc]init];
    [pageControl setCenter:CGPointMake(self.view.center.x,initialVC.view.frame.size.height-10)];
    [pageControl setNumberOfPages:[_arrayTitulos count]];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    
    
    [self.view addSubview:pageControl];
    
    
}

- (RFMContentTutorialViewController *)viewControllerAtIndex: (NSUInteger) index
{
    if (index>_arrayTitulos.count-1) {
        return nil;
    }
    RFMContentTutorialViewController *cVC = [[RFMContentTutorialViewController alloc]init];
    [cVC setDataObject1:[_arrayTitulos objectAtIndex:index]];
    [cVC setDataObject2:[_arrayTextos objectAtIndex:index]];
    switch (index) {
        case 0:
            [cVC.view setBackgroundColor:[UIColor yellowColor]];
            break;
        case 1:
            [cVC.view setBackgroundColor:[UIColor blueColor]];
            break;
        case 2:
            [cVC.view setBackgroundColor:[UIColor orangeColor]];
            break;
        case 3:
            [cVC.view setBackgroundColor:[UIColor greenColor]];
            break;
        case 4:
            [cVC.view setBackgroundColor:[UIColor grayColor]];
            break;
        case 5:
            [cVC.view setBackgroundColor:[UIColor purpleColor]];
            break;
        default:
            break;
    }
    
    return cVC;
}

- (NSInteger) indexOfViewController:(RFMContentTutorialViewController *) viewController
{
    return [_arrayTitulos indexOfObject:viewController.dataObject1];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(RFMContentTutorialViewController *)viewController];
    [pageControl setCurrentPage:index];
    if (index==0 || index==NSNotFound) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(RFMContentTutorialViewController *)viewController];
    [pageControl setCurrentPage:index];
    if (index==NSNotFound) {
        return nil;
    }
    index++;
    
    return [self viewControllerAtIndex:index];
}

@end
