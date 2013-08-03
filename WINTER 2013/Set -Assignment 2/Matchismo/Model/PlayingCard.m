//
//  PlayingCard.m
//  Matchismo
//
//  Created by Apple on 24/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit; // because we provide setter AND getter

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] == 1)
    {
             
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit])
        {
            score = 2;
        }
        else if (otherCard.rank == self.rank)
        {
            score = 5;
        }
        
     else if ([otherCards count] == 2)
     {
        PlayingCard *secondCard = otherCards[0];
        PlayingCard *thirdCard = otherCards[1];
        score = [self match:@[secondCard]] + [self match:@[thirdCard]] + [secondCard match:@[thirdCard]];
     }
    
    }
    
    return score;
}

- (NSString *)contents
{
     NSArray *rankStrings = [PlayingCard rankStrings];
 
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♥", @"♦", @"♠", @"♣"];
    return validSuits;
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9" ,@"10",@"J",@"Q",@"k"];
    return rankStrings;
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count-1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

@end