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
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSString *result;
@property (readonly, nonatomic) NSArray *cardsFromResult; // of Card
@property (strong, nonatomic) NSString *gameName;
@property (nonatomic) int numberOfCardsToMatch;
@property (nonatomic) CGFloat matchBonusMultiplier;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;

@end
