//
//  RFMTutorialCollectionModel.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 19/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTutorialModel.h"
#import "RFMTutorialScreenModel.h"

@interface RFMTutorialModel()

@end

@implementation RFMTutorialModel
#pragma mark - Properties
-(NSInteger) tutorialScreensCount
{
    return [self.tutorialScreens count];
}
#pragma mark - Init
- (id)init
{    
    if (self = [super init]) {
        RFMTutorialScreenModel *screen1 = [[RFMTutorialScreenModel alloc] initWithTitle:NSLocalizedString(@"TUTORIAL_Title1",nil)
                                                                    content:NSLocalizedString(@"TUTORIAL_Text1",nil)
                                                                      image: [UIImage imageNamed:@"tutorial1"]];
        RFMTutorialScreenModel *screen2 = [[RFMTutorialScreenModel alloc] initWithTitle:NSLocalizedString(@"TUTORIAL_Title2",nil)
                                                                    content:NSLocalizedString(@"TUTORIAL_Text2",nil)
                                                                      image: [UIImage imageNamed:@"tutorial2"]];
        RFMTutorialScreenModel *screen3 = [[RFMTutorialScreenModel alloc] initWithTitle:NSLocalizedString(@"TUTORIAL_Title3",nil)
                                                                    content:NSLocalizedString(@"TUTORIAL_Text3",nil)
                                                                      image: [UIImage imageNamed:@"tutorial3"]];
        RFMTutorialScreenModel *screen4 = [[RFMTutorialScreenModel alloc] initWithTitle:NSLocalizedString(@"TUTORIAL_Title4",nil)
                                                                    content:NSLocalizedString(@"TUTORIAL_Text4",nil)
                                                                      image: [UIImage imageNamed:@"tutorial4"]];
        RFMTutorialScreenModel *screen5 = [[RFMTutorialScreenModel alloc] initWithTitle:NSLocalizedString(@"TUTORIAL_Title5",nil)
                                                                    content:NSLocalizedString(@"TUTORIAL_Text5",nil)
                                                                      image: [UIImage imageNamed:@"tutorial5"]];
        RFMTutorialScreenModel *screen6 = [[RFMTutorialScreenModel alloc] initWithTitle:NSLocalizedString(@"TUTORIAL_Title6",nil)
                                                                    content:NSLocalizedString(@"TUTORIAL_Text6",nil)
                                                                      image: [UIImage imageNamed:@"tutorial6"]];
        self.tutorialScreens = @[screen1, screen2, screen3, screen4, screen5, screen6];
    }    
    return self;
}

- (RFMTutorialScreenModel *)tutorialScreenAtIndex:(NSInteger)index
{
    return [self.tutorialScreens objectAtIndex:index];
}
@end
