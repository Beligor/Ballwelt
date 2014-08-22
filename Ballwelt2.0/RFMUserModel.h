//
//  RFMDataUserModel.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 21/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFMUserModel : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *nickname;
@property (nonatomic) NSInteger highScore;
@property (strong, nonatomic) NSString *date;
@property (nonatomic) BOOL recordSended;


- (void)saveData;
@end
