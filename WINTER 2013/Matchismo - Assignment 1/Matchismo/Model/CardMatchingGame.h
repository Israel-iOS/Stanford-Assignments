//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Apple on 24/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// Designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

- (void)reset;

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSString *flipResult;
@property (readonly, nonatomic) NSMutableArray *flipHistory;
@property (nonatomic, getter = isMatch3mode) BOOL match3mode;

@end
