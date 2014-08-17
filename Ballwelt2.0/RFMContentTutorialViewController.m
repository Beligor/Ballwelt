//
//  RFMContentTutorialViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMContentTutorialViewController.h"

@interface RFMContentTutorialViewController ()

@end

@implementation RFMContentTutorialViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.titleString setText:self.dataObject1];
    [self.textString setText:self.dataObject2];
}

@end
