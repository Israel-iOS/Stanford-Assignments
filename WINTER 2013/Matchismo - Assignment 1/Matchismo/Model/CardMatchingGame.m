//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Apple on 24/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic) int score;
@property (readwrite, nonatomic) NSString *flipResult;
@property (nonatomic, strong) NSMutableArray *cards;
@property (readwrite, nonatomic) NSMutableArray *flipHistory;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards)
        _cards = [[NSMutableArray alloc] init];
    
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        for (int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            if (card)
            {
                self.cards[i] = card; // lazy instantiation
            }
            else
            {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory)
        _flipHistory = [[NSMutableArray alloc] init];
    
    return _flipHistory;
}

- (void)setFlipResult:(NSString *)flipResult
{
    _flipResult = flipResult;
    [self.flipHistory addObject:_flipResult];
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)reset
{
    self.score = 0;
    self.flipResult = @"Matchismo!";
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

-(void)flipCardAtIndex:(NSUInteger)index
{
    // Set default state for lastFlipLabel
    self.flipResult = [NSString stringWithFormat:@"Remember: flipping up a card costs 1 point..."];
    
    Card *card = [self cardAtIndex:index];
    if (card && !card.isUnplayable)
    {
        if (!card.isFaceUp)
        {
            // Match: 2 cards, gameMode = 0
            if (!self.match3mode)
            {
                self.flipResult = [NSString stringWithFormat:@"Flipped up %@, costs %d penalty point", card.contents, FLIP_COST];
                for (Card *otherCard in self.cards)
                {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable)
                    {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            card.unplayable = YES;
                            otherCard.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            self.flipResult = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", card.contents, otherCard.contents, matchScore * MATCH_BONUS];
                        }
                        else
                        {
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                            self.flipResult = [NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty", card.contents, otherCard.contents, MISMATCH_PENALTY];
                        }
                        break;
                    }
                }
                self.score -= FLIP_COST; // There is no cost for flipping the card back down.
            }
            
            // Match: 3 cards, gameMode = 1
            else if (self.isMatch3mode)
            {
                NSMutableArray *playedCards = [[NSMutableArray alloc] init];
                for (Card *otherCard in self.cards)
                {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable)
                    {
                        [playedCards addObject:otherCard];
                    }
                }
                self.flipResult = [NSString stringWithFormat:@"Flipped up %@, costs %d penalty point", card.contents, FLIP_COST];
                if ([playedCards count] == 1)
                {
                    int matchScore = [card match:playedCards];
                    if (!matchScore)
                    {
                        for (Card *otherCard in playedCards)
                        {
                            otherCard.faceUp = NO;
                        }
                        self.score -= MISMATCH_PENALTY;
                        self.flipResult = [NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty", card.contents, [playedCards[0] contents], MISMATCH_PENALTY];
                    }
                }
                else if ([playedCards count] == 2)
                {
                    int matchScore = [card match:playedCards];
                    if (matchScore)
                    {
                        card.unplayable = YES;
                        for (Card *otherCard in playedCards)
                        {
                            otherCard.unplayable = YES;
                        }
                        self.score += matchScore * MATCH_BONUS;
                        self.flipResult = [NSString stringWithFormat:@"Matched %@, %@ & %@ for %d points",card.contents,[playedCards[0] contents], [playedCards[1] contents], matchScore * MATCH_BONUS];
                    }
                    else
                    {
                        for (Card *otherCard in playedCards)
                        {
                            otherCard.faceUp = NO;
                        }
                        self.score -= MISMATCH_PENALTY;
                        self.flipResult = [NSString stringWithFormat:@"%@, %@ and %@ don't match! %d point penalty",card.contents,[playedCards[0] contents],[playedCards[1] contents], MISMATCH_PENALTY];
                    }
                }
                self.score -= FLIP_COST;
            }
        }
        card.faceUp = !card.faceUp;
    }
}

@end
