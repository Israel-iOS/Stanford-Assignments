//
//  MatchSectionHeaderReusableView.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MatchSectionHeaderReusableView.h"

@implementation MatchSectionHeaderReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSMutableAttributedString *headerTitle = [[NSMutableAttributedString alloc] initWithString:@"Matches"];
    
    [headerTitle setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18],
NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) }
                         range:NSMakeRange(0, headerTitle.length)];
    
    CGSize headerTitleSize = [headerTitle size];
    CGRect titleRect = CGRectMake(rect.size.width/2 - headerTitleSize.width/2, rect.size.height/2 - headerTitleSize.height/2, headerTitleSize.width, headerTitleSize.height);
    [headerTitle drawInRect:titleRect];
}

@end
