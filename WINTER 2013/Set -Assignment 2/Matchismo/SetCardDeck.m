//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Apple on 04/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck
- (id)init
{
    self = [super init];
    
    for (int number = 1; number <= [SetCard maxNumber]; number++)
    {
        for (NSString *symbol in [SetCard validSymbols])
        {
            for (NSString *shade in [SetCard validShades])
            {
                for (NSString *color in [SetCard validColors])
                {
                    SetCard *card = [[SetCard alloc] init];
                    card.number = number;
                    card.symbol = symbol;
                    card.shade = shade;
                    card.color = color;
                    [self addCard:card atTop:YES];
                }
            }
        }
    }
    
    return self;
}

@end
