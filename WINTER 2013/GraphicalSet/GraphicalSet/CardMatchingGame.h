//
//  CardMatchingGame.h
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

// Designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

- (NSUInteger)cardsInPlayCount;

- (NSUInteger)matchesCount;

// Returns card that have been played, nil if no more cards could be played from the deck
- (Card *)drawCardFromDeck;

// Returns YES if there are still cards in the deck to play
- (BOOL)hasDrawableCards;

- (void)removeCardsAtIndexes:(NSIndexSet *)indexes;

// Returns NSArray of Card for a valid match index
- (NSArray *)matchAtIndex:(NSUInteger)index;

// Returns a match if one exists, empty index set if none
- (NSIndexSet *)findMatch;

// Penalize the player's game score. Penalty is the amount that will be subtracted from the score.
- (void)addPenalty:(NSUInteger)penalty;

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSString *result;
@property (readonly, nonatomic) NSArray *cardsFromResult; // of Card
@property (strong, nonatomic) NSString *gameName;
@property (nonatomic) int numberOfCardsToMatch;
@property (nonatomic) CGFloat matchBonusMultiplier;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;

@end
