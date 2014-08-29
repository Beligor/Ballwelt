//
//  RFMButtonView.m
//  Ballwelt2.0
//
//  Created by Rafa Ferrero on 28/08/14.
//  Copyright (c) 2014 Rafa Ferrero. All rights reserved.
//

#import "RFMButtonView.h"

@implementation RFMButtonView

-(void)customizeAppearance
{
    self.backgroundColor = Rgb2UIColor(69, 24, 46);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 4.0;
    [self sizeToFit];
    self.layer.cornerRadius = self.frame.size.height/2;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + 20, size.height);
}
@end
