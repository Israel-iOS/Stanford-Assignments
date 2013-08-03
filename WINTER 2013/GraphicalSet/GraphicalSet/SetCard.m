//
//  SetCard.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

// Format: number, symbol, color, shade
- (NSString *)contents
{
    return [NSString stringWithFormat:@"%d|%d|%d|%d", self.number, self.symbol, self.color, self.shade];
}

- (void)setSymbol:(NSUInteger)symbol
{
    if ([[SetCard validSymbols] containsObject:@(symbol)])
    {
        _symbol = symbol;
    }
}

- (void)setShade:(NSUInteger)shade
{
    if ([[SetCard validShades] containsObject:@(shade)])
    {
        _shade = shade;
    }
}

- (void)setColor:(NSUInteger)color
{
    if ([[SetCard validColors] containsObject:@(color)])
    {
        _color = color;
    }
}

- (void)setNumber:(NSUInteger)number
{
    if ([[SetCard validNumbers] containsObject:@(number)])
    {
        _number = number;
    }
}

- (int)match:(NSArray *)otherCards
{
    NSArray *allCards = [otherCards arrayByAddingObject:self];
    
    // Must be three set cards for it to be a valid match
    if ([allCards count] == 3) {
        // To evaluate match, we exploit a principle that for any given attribute (shape, color, symbol, number)
        // that is represented by 1, 2, or 3, for three cards to be a match in any given attribute, the combination
        // of numbers for that attribute can only be (1, 1, 1), (2, 2, 2), (3, 3, 3), and (1, 2, 3). The sum of these
        // numbers can only be in {3, 6, 9}. Any other combination of 1, 2, and 3 that is *not* considered a set will *not*
        // be 3, 6, or 9.
        SetCard *card1 = (SetCard *)allCards[0];
        SetCard *card2 = (SetCard *)allCards[1];
        SetCard *card3 = (SetCard *)allCards[2];
        NSSet *set = [[NSSet alloc] initWithArray:@[@(3), @(6), @(9)]];
        return [set containsObject:@(card1.symbol + card2.symbol + card3.symbol)] &&
        [set containsObject:@(card1.shade + card2.shade + card3.shade)] &&
        [set containsObject:@(card1.number + card2.number + card3.number)] &&
        [set containsObject:@(card1.color + card2.color + card3.color)];
    }
    
    return 0;
}

+ (NSArray *)validSymbols
{
    return @[@(1), @(2), @(3)];
}

+ (NSArray *)validShades
{
    return @[@(1), @(2), @(3)];
}

+ (NSArray *)validColors
{
    return @[@(1), @(2), @(3)];
}

+ (NSArray *)validNumbers
{
    return @[@(1), @(2), @(3)];
}

@end
