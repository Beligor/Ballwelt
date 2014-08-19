//
//  RFMContentTutorialViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMContentTutorialViewController.h"
#import "RFMTutorialModel.h"

@implementation RFMContentTutorialViewController

#pragma mark - Init
-(id) initWithModel:(RFMTutorialModel *)aModel
{
    if (self = [super init]) {
        _model = aModel;
    }
    return self;
}


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundPlayScreen"]];
    [self.titleLabel setText: self.model.title];
    [self.textLabel setText: self.model.content];
    self.image.image = self.model.image;    
}

@end
