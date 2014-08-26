//
//  RFMDataUserModel.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 21/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMUserModel.h"

@implementation RFMUserModel

#pragma mark - Init
-(id)init
{
    if (self = [super init]) {
        [self readData];
    }
    return self;
}

#pragma mark - Plist File
- (void)readData
{
    NSString *path = [self findFile];
    
    // Save Plist file data into a dictionary
    NSMutableDictionary *dataFromPlistFile = [[NSMutableDictionary alloc] initWithContentsOfFile: path];

    // Assign to iVar content of dictionary
    _ID = [dataFromPlistFile objectForKey:@"ID"];
    _nickname = [dataFromPlistFile objectForKey:@"nickname"];
    _highScore = [[dataFromPlistFile objectForKey:@"highScore"] intValue];
    _date = [dataFromPlistFile objectForKey:@"date"];
    _recordSended = [[dataFromPlistFile objectForKey:@"recordSended"] boolValue];
}

- (NSString *)findFile
{
    // Get path to Document directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Add name of our plist file to the path
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
    
    // Default file manager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if (![fileManager fileExistsAtPath:path]) {
        // If file doesn't exists into Documents directory, copy it from our Bundle
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"userData"
                                                           ofType:@"plist"];
        [fileManager copyItemAtPath:bundle
                             toPath:path
                              error:&error];
    }
    return path;
}

- (void)saveData
{
    
    NSString *path = [self findFile];
    
    NSDictionary *dataToWriteInPlistFile = @{@"ID" : self.ID,
                                             @"nickname" : self.nickname,
                                             @"highScore" : [NSNumber numberWithInteger:self.highScore],
                                             @"date" : [self transformDateIntoString],
                                             @"recordSended" : [NSNumber numberWithBool:self.recordSended]};
                                             
    [dataToWriteInPlistFile writeToFile:path
                             atomically:YES];
    
}

#pragma mark - Utils
- (NSString *)transformDateIntoString
{
    // Return a string with date in format yyyymmdd
    NSDate *today = [NSDate date];
    
    // Separate date in components
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                                       fromDate:today];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    
    NSString *monthString;
    NSString *dayString;
    
    // Ensure that day and month have 2 digits
    if (month < 10) {
        monthString = [NSString stringWithFormat:@"0%i", (int)month];
    }else{
        monthString = [NSString stringWithFormat:@"%i", (int)month];
    }
    
    if (day < 10) {
        dayString = [NSString stringWithFormat:@"0%i", (int)day];
    }else{
        dayString = [NSString stringWithFormat:@"%i", (int)day];
    }
    
    return [NSString stringWithFormat:@"%i%@%@", (int)year,monthString, dayString] ;
}

@end
