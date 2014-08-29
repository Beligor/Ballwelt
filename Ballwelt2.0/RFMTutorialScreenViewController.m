//
//  RFMContentTutorialViewController.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 17/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTutorialScreenViewController.h"
#import "RFMTutorialScreenModel.h"
#import "RFMButtonView.h"

@implementation RFMTutorialScreenViewController

#pragma mark - Init
-(id) initWithModel:(RFMTutorialScreenModel *) aModel
         showButton:(BOOL) showButton
{
    if (self = [super init]) {
        _model = aModel;
        _showButton = showButton;
    }
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundPlayScreen"]];
    
    [self.titleLabel setText: self.model.title];
    [self.contentLabel setText: self.model.content];
    self.image.image = self.model.image;
    
    [self.closeButton setTitle: NSLocalizedString(@"TUTORIAL_Close", nil)
                      forState: UIControlStateNormal];
    [self.closeButton customizeAppearance];
    
    self.closeButton.hidden = !self.showButton;
    
}

#pragma mark - Actions
- (IBAction)closeTutorial:(id)sender
{
    [self.delegate willCloseTutorial];
}
@end
