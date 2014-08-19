//
//  RFMTutorialCollectionModel.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 19/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RFMTutorialScreenModel;

@interface RFMTutorialModel : NSObject

@property (nonatomic) NSInteger tutorialScreensCount;
@property (strong, nonatomic) NSArray *tutorialScreens;

-(RFMTutorialScreenModel *) tutorialScreenAtIndex:(NSInteger) index;

@end
