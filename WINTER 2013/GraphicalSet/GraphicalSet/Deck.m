//
//  Deck.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "Deck.h"

@interface Deck ()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation Deck

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop)
    {
        [self.cards insertObject:card atIndex:0];
    }
    else
    {
        [self.cards addObject:card];
    }
}

- (Card *)drawRandomCard
{
    Card *card;
    
    if (self.cards.count)
    {
        unsigned index = arc4random() % self.cards.count;
        card = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return card;
}

- (BOOL)hasDrawableCards
{
    return ([self.cards count]);
}

@end
