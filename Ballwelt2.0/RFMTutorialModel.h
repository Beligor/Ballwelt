//
//  RFMTutorialModel.h
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 19/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFMTutorialModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIImage *image;

-(id) initWithTitle:(NSString *) aTitle
            content:(NSString *) aContent
              image:(UIImage *) anImage;

@end
