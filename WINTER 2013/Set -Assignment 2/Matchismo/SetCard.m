//
//  SetCard.m
//  Matchismo
//
//  Created by Apple on 04/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (NSString *)contents
{
    return [@"" stringByPaddingToLength:self.number
                             withString:self.symbol
                        startingAtIndex:0];
}

@synthesize symbol = _symbol;

- (NSString *)symbol
{
    if (!_symbol) _symbol = @"?";
    return _symbol;
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol])
    {
        _symbol = symbol;
    }
}

@synthesize shade = _shade;

- (NSString *)shade
{
    if (!_shade) _shade = @"?";
    return _shade;
}

- (void)setShade:(NSString *)shade
{
    if ([[SetCard validShades] containsObject:shade])
    {
        _shade = shade;
    }
}

@synthesize color = _color;

- (NSString *)color
{
    if (!_color) _color = @"?";
    return _color;
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color])
    {
        _color = color;
    }
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber])
    {
        _number = number;
    }
}

- (int)match:(NSArray *)otherCards
{
    NSArray *allCards = [otherCards arrayByAddingObject:self];
    int allCardsCount = [allCards count];
    
    // Test for similarity or for mutual exclusion
    NSSet *setOfSymbols = [[NSMutableSet alloc] initWithArray:[allCards valueForKey:@"symbol"]];
    NSSet *setOfNumbers = [[NSMutableSet alloc] initWithArray:[allCards valueForKey:@"number"]];
    NSSet *setOfShades = [[NSMutableSet alloc] initWithArray:[allCards valueForKey:@"shade"]];
    NSSet *setOfColors = [[NSMutableSet alloc] initWithArray:[allCards valueForKey:@"color"]];
    
    if (([setOfSymbols count] == 1 || [setOfSymbols count] == allCardsCount) &&
        ([setOfNumbers count] == 1 || [setOfNumbers count] == allCardsCount) &&
        ([setOfShades count] == 1 || [setOfShades count] == allCardsCount) &&
        ([setOfColors count] == 1 || [setOfColors count] == allCardsCount))
    {
        return 1;
    }
    return 0;
}

+ (NSArray *)validSymbols
{
    return @[@"▲", @"●", @"■"];
}

+ (NSArray *)validShades
{
    return @[@"solid", @"shaded", @"open"];
}

+ (NSArray *)validColors
{
    return @[@"red", @"green", @"purple"];
}

+ (NSUInteger)maxNumber
{
    return 3;
}

@end
