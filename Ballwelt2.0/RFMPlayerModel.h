//
//  RFMPlayerModel.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 20/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFMPlayerModel : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *position;

-(id)initWithID:(NSString *) anID
           name:(NSString *) aName
          score:(NSString *) aScore
           date:(NSString *) aDate
       position:(NSString *) aPosition;

-(id)initWithDictionary:(NSDictionary *) aDict;
@end
