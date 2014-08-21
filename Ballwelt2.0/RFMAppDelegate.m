//
//  RFMAppDelegate.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 08/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMAppDelegate.h"
#import "RFMMainMenuViewController.h"
@implementation RFMAppDelegate

#pragma mark - Appearance
-(void)customizeAppearance
{

    [[UIButton appearanceWhenContainedIn:[RFMMainMenuViewController class],  nil] setBackgroundColor:Rgb2UIColor(69, 24, 46)];
    [[UIButton appearanceWhenContainedIn:[RFMMainMenuViewController class],  nil] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedIn:[RFMMainMenuViewController class],  nil].titleLabel setFont:[UIFont systemFontOfSize:35]];
    [[UIButton appearanceWhenContainedIn:[RFMMainMenuViewController class],  nil].layer setBorderColor:[UIColor blackColor].CGColor];
    [[UIButton appearanceWhenContainedIn:[RFMMainMenuViewController class],  nil].layer setBorderWidth:4.0];
    [[UIButton appearanceWhenContainedIn:[RFMMainMenuViewController class],  nil].layer setCornerRadius:10];
    
}

#pragma mark - Notifications
-(void)sendNotification
{
    NSNotification *n = [NSNotification notificationWithName:@"pauseGame"
                                                      object:self
                                                    userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
   // [self customizeAppearance];
    
    
   RFMMainMenuViewController *menuVC = [[RFMMainMenuViewController alloc] init];
//    RFMRankingViewController *rankVC = [[RFMRankingViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:menuVC];
    navVC.navigationBar.hidden = YES;
    
    self.window.rootViewController = navVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    // Enviar notificación
    [self sendNotification];
//    NSNotification *n = [NSNotification notificationWithName:@"pauseGame"
//                                                      object:self
//                                                    userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self sendNotification];
//    NSNotification *n = [NSNotification notificationWithName:@"pauseGame"
//                                                      object:self
//                                                    userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:n];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
