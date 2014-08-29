//
//  RFMRanking.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 20/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMRanking.h"
#import "RFMPlayerModel.h"

@interface RFMRanking()
@property (strong, nonatomic) RFMPlayerModel *playerModel;
@property (strong, nonatomic) NSMutableDictionary *currentDic;
@property (strong, nonatomic) NSMutableString *currentNode;
@property (strong, nonatomic) NSString *tbl;
@property (strong, nonatomic) NSString *db;
@end

@implementation RFMRanking

#pragma mark - Properties
-(NSUInteger) playersCount
{
    return [self.playersList count];
}

#pragma mark - Init
-(id) init
{
    if (self = [super init]) {
        _db = @"Ballwelt";
        _tbl = @"ranking";
        [self downloadTop10];
    }
    return self;
}

#pragma mark - XML Parser
-(id)showOutOfTop10PositionForPlayerWithID:(NSString *) ID
{
    NSURL *URL = [NSURL URLWithString: [NSString stringWithFormat:@"http://macuversium.mooo.com/www/Ballwelt_fueraTop10.php?usr=BallweltSQL&pass=optHKUZwe2RqD7bJNaTM&db=%@&tbl=%@&id=%@", self.db, self.tbl, ID]];
    [self executeParserWithURL:URL];
    
    if ([self.playersList count] >10) { //Check if player has a score in server
        RFMPlayerModel *player = [self.playersList objectAtIndex:10];
        [self.playersList removeLastObject];
        return player;
    }
    return nil;
}

-(void)downloadTop10
{
    NSURL *URL = [NSURL URLWithString: [NSString stringWithFormat:@"http://macuversium.mooo.com/www/connect.php?usr=BallweltSQL&pass=optHKUZwe2RqD7bJNaTM&db=%@&tbl=%@", self.db, self.tbl]];
    [self executeParserWithURL:URL];    
}

-(BOOL)checkIfPlayerWithIDIsInTop10:(NSString *) ID
{
    for (RFMPlayerModel *each in self.playersList) {
        if ([each.ID isEqualToString: ID]) {
            return YES;
        }
    }
    return NO;
}

-(void)executeParserWithURL:(NSURL *) URL
{
    NSXMLParser *XMLParser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
    XMLParser.delegate = self;
    [XMLParser parse];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString: self.tbl]) {
        self.currentDic = [[NSMutableDictionary alloc]init ];
        self.currentNode = [[NSMutableString alloc]init];
        
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Nombre"]) {
        [self.currentDic setValue: self.currentNode forKey:@"Nombre"];
    }else if ([elementName isEqualToString:@"Puntuacion"]) {
        [self.currentDic setValue: self.currentNode forKey:@"Puntuacion"];
    }else if ([elementName isEqualToString:@"Fecha"]) {
        [self.currentDic setValue: self.currentNode forKey:@"Fecha"];
    }else if ([elementName isEqualToString:@"UDID"]) {
        [self.currentDic setValue: self.currentNode forKey:@"UDID"];
    }else if ([elementName isEqualToString:@"rank"]) {
        [self.currentDic setValue: self.currentNode forKey:@"rank"];
    }
    
    
    if ([elementName isEqualToString: self.tbl]) {
        self.playerModel = [[RFMPlayerModel alloc] initWithDictionary: self.currentDic];
        if (!self.playersList) {
            self.playersList = [NSMutableArray arrayWithObject: self.playerModel];
        }else{
            [self.playersList addObject: self.playerModel];
        }
    }
    self.currentNode = nil;
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
    if (!self.currentNode) {
        self.currentNode = [[NSMutableString alloc] initWithString:string];
    }else{
        [self.currentNode appendString:string];
    }
}


#pragma mark - Other
- (id)playerInPosition:(NSUInteger)aPosition
{
    return [self.playersList objectAtIndex:aPosition];
}
@end
