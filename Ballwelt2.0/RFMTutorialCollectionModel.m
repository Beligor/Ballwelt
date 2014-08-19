//
//  RFMTutorialCollectionModel.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 19/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTutorialCollectionModel.h"
#import "RFMTutorialModel.h"

@interface RFMTutorialCollectionModel()

@end

@implementation RFMTutorialCollectionModel
#pragma mark - Properties
-(NSInteger) tutorialScreensCount
{
    return [self.tutorialScreens count];
}
#pragma mark - Init
- (id)init
{
    if (self = [super init]) {
        RFMTutorialModel *screen1 = [[RFMTutorialModel alloc] initWithTitle:@"titulo 1"
                                                                    content:@"contenido 1"
                                                                      image: [UIImage imageNamed:@"tutorial1"]];
        RFMTutorialModel *screen2 = [[RFMTutorialModel alloc] initWithTitle:@"titulo 2"
                                                                    content:@"contenido 2"
                                                                      image: [UIImage imageNamed:@"tutorial2"]];
        RFMTutorialModel *screen3 = [[RFMTutorialModel alloc] initWithTitle:@"titulo 3"
                                                                    content:@"contenido 3"
                                                                      image: [UIImage imageNamed:@"tutorial3"]];
        RFMTutorialModel *screen4 = [[RFMTutorialModel alloc] initWithTitle:@"titulo 4"
                                                                    content:@"contenido 4"
                                                                      image: [UIImage imageNamed:@"tutorial4"]];
        RFMTutorialModel *screen5 = [[RFMTutorialModel alloc] initWithTitle:@"titulo 5"
                                                                    content:@"contenido 5"
                                                                      image: [UIImage imageNamed:@"tutorial5"]];
        RFMTutorialModel *screen6 = [[RFMTutorialModel alloc] initWithTitle:@"titulo 6"
                                                                    content:@"contenido 6"
                                                                      image: [UIImage imageNamed:@"tutorial6"]];
        self.tutorialScreens = @[screen1, screen2, screen3, screen4, screen5, screen6];
    }    
    return self;
}

- (RFMTutorialModel *)tutorialScreenAtIndex:(NSInteger)index
{
    return [self.tutorialScreens objectAtIndex:index];
}
@end
