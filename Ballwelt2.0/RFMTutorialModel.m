//
//  RFMTutorialModel.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 19/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMTutorialModel.h"

@implementation RFMTutorialModel

-(id) initWithTitle:(NSString *) aTitle
            content:(NSString *) aContent
              image:(UIImage *) anImage
{
    if (self = [super init]) {
        _title = aTitle;
        _content = aContent;
        _image = anImage;
    }
    return self;
}

@end
