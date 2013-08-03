//
//  MatchCollectionViewCell.m
//  GraphicalSet
//
//  Created by Apple on 10/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MatchCollectionViewCell.h"

@interface MatchCollectionViewCell ()

@property (strong, nonatomic) NSMutableArray *cardViews; // of UIView

@end

@implementation MatchCollectionViewCell

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    
    return _cardViews;
}

// Adds UIView sequentially to the cell
- (void)setCardView:(UIView *)cardView atPosition:(NSUInteger)position
{
    if (cardView)
    {
        self.cardViews[position] = cardView;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

#define SPACER 2

- (void)drawRect:(CGRect)rect
{
    if ([self.cardViews count])
    {
        CGFloat availableWidth = rect.size.width - (SPACER * ([self.cardViews count]-1));
        
        CGFloat widthOfEachCardSubview = availableWidth / [self.cardViews count];
        
        CGFloat xCoordinateCount = 0;
        
        for (int i = 0; i < [self.cardViews count]; i++)
        {
            if ([self.cardViews[i] isKindOfClass:[UIView class]])
            {
                UIView *cardView = self.cardViews[i];
                cardView.frame = CGRectMake(xCoordinateCount, 0, widthOfEachCardSubview, rect.size.height);
                [self addSubview:cardView];
                xCoordinateCount += widthOfEachCardSubview;
                if (i != [self.cardViews count]-1) xCoordinateCount += SPACER;
            }
        }
    }
}

@end
