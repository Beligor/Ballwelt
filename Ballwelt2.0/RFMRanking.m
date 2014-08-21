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
@property (strong, nonatomic) NSMutableArray *playersList;
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
        [self downloadRanking];
    }
    return self;
}

#pragma mark - XML Parser
-(void) downloadRanking
{
    self.db = @"Ballwelt";
    self.tbl = @"ranking";
    NSURL *URL = [NSURL URLWithString: [NSString stringWithFormat:@"http://macuversium.mooo.com/www/connect.php?usr=BallweltSQL&pass=optHKUZwe2RqD7bJNaTM&db=%@&tbl=%@", self.db, self.tbl]];
    
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
- (id)playerAtIndex:(NSUInteger)index
{
    return [self.playersList objectAtIndex:index];
}
@end
