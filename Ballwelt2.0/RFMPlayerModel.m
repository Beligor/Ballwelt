//
//  RFMPlayerModel.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 20/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMPlayerModel.h"

@implementation RFMPlayerModel

#pragma mark - XML

-(id)initWithDictionary:(NSDictionary *) aDict
{
    return [self initWithID:[aDict objectForKey:@"UDID"]
                       name:[aDict objectForKey:@"Nombre"]
                      score:[aDict objectForKey:@"Puntuacion"]
                       date:[aDict objectForKey:@"Fecha"]
                   position:[aDict objectForKey:@"rank"]];
}

//-(NSDictionary *)proxyForXML{
//    
//    return @{@"UDID"        : self.ID,
//             @"Nombre"      : self.name,
//             @"Puntuacion"  : self.score,
//             @"Fecha"       : self.date,
//             @"rank"        : self.position};
//}

#pragma mark - Init
-(id)initWithID:(NSString *) anID
           name:(NSString *) aName
          score:(NSString *) aScore
           date:(NSString *) aDate
       position:(NSString *) aPosition
{
    if (self = [super init]) {
        _ID = anID;
        _name = aName;
        _score = aScore;
        _date = aDate;
        _position = aPosition;
    }
    return self;
}

#pragma mark - Utils
- (NSString *)description
{
    return [NSString stringWithFormat:@"\nUDID: %@ \nName: %@ \nScore: %@\nDate: %@\nPosition: %@", self.ID, self.name, self.score, self.date, self.position];
}

@end
