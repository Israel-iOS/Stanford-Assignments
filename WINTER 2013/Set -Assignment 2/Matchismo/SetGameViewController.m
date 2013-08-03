//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Apple on 04/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSString *)gameName
{
    return @"Set Game";
}

- (int)numberOfCardsToMatch
{
    return 3;
}

- (int)flipCost
{
    return 1;
}

- (int)mismatchPenalty
{
    return 2;
}

- (CGFloat)matchBonusMultiplier
{
    return 3;
}

// Implements/overrides the superclass method
- (void)updateButton:(UIButton *)cardButton withCard:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]])
    {
        SetCard *setCard = (SetCard *)card;
        
        NSMutableAttributedString *mutableAttributedString = [[[self class] attributedStringFromSetCard:setCard] mutableCopy];
        // We want a bigger font size for our buttons
        [mutableAttributedString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} range:NSMakeRange(0, setCard.number)];
        NSAttributedString *attributedString = [mutableAttributedString copy];
        
        // Set the attributed string as the title for the front and back of the card...
        [cardButton setAttributedTitle:attributedString forState:UIControlStateSelected];
        [cardButton setAttributedTitle:attributedString forState:UIControlStateNormal];
        
        // If the card is "face up" i.e. selected, change background color of button to show that it's selected
        if (setCard.isFaceUp) [cardButton setBackgroundColor:[UIColor lightGrayColor]];
        else [cardButton setBackgroundColor:nil];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        // If the card is unplayable, make it disappear
        cardButton.alpha = card.isUnplayable ? 0 : 1;
    }
}

// Implements/overrides the superclass method -- this method updates the result label with either a flip history result NSAttributedString or a game result NSString.
- (void)updateResultLabel:(UILabel *)label withObject:(id)object
{
    if (label)
    {
        if (!object) label.attributedText = nil;
        // Received request to display an attributed string (from flipHistory)
        else if ([object isKindOfClass:[NSAttributedString class]])
        {
            label.attributedText = object;
        }
    }
}

// Overrides the superclass method
- (id)formatResult:(NSString *)result
          forCards:(NSArray *)cards
{
    return [[self class] attributedStringFromResultString:result withCards:cards];
}

// Precondition: cards array is sorted in the same order that they appear in resultString (which should be implemented in CardMatchingGame.h)
+ (NSAttributedString *)attributedStringFromResultString:(NSString *)resultString
                                               withCards:(NSArray *)cards
{
    NSMutableAttributedString *mutableAttributedString = nil;
    
    if (resultString)
    {
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:resultString];
        NSRange searchRange = NSMakeRange(0, resultString.length);
        
        for (SetCard *card in cards)
        {
            NSRange cardRange = [resultString rangeOfString:card.contents
                                                    options:NSLiteralSearch
                                                      range:searchRange];
            if (cardRange.location != NSNotFound) {
                [mutableAttributedString addAttributes:[[self class] attributesForSetCard:card]
                                                 range:cardRange];
            }
            searchRange.location = cardRange.location + cardRange.length;
            searchRange.length = resultString.length - searchRange.location;
        }
    }
    
    [mutableAttributedString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}
                                     range:NSMakeRange(0, [resultString length])];
    
    return [mutableAttributedString copy];
}

+ (NSAttributedString *)attributedStringFromSetCard:(SetCard *)card
{
    NSAttributedString *attributedString = nil;
    
    if (card)
    {
        NSDictionary *attributes = [[self class]attributesForSetCard:card];
        attributedString = [[NSAttributedString alloc] initWithString:card.contents attributes:attributes];
    }
    
    return attributedString;
}

+ (NSDictionary *)attributesForSetCard:(SetCard *)card
{
    NSDictionary *attributes = nil;
    
    if (card)
    {
        // Get color for this card. Note that if the symbol has a shade setting of "shaded", we use transparency to draw it as such
        UIColor *strokeColor = [[self class]colorForSetCard:card withAlpha:1];
        UIColor *fillColor = ([card.shade isEqualToString:@"shaded"]) ?
        [[self class]colorForSetCard:card withAlpha:.3] :
        strokeColor;
        
        // If symbol has shade setting of "open", we want to draw the outline only, so we set the stroke width to a positive NSNumber.
        NSNumber *strokeWidth = @-10;
        if ([card.shade isEqualToString:@"open"])
        {
            strokeWidth = @10;
        }
        
        attributes = @{NSForegroundColorAttributeName : fillColor,
                       NSStrokeColorAttributeName : strokeColor,
                       NSStrokeWidthAttributeName : strokeWidth };
    }
    
    return attributes;
}

+ (UIColor *)colorForSetCard:(SetCard *)card withAlpha:(CGFloat)alpha
{
    UIColor *color = nil;
    
    if (card)
    {
        if ([card.color isEqualToString:@"red"])
        {
            color = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:alpha];
        }
        else if ([card.color isEqualToString:@"green"])
        {
            color = [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:alpha];
        }
        else if ([card.color isEqualToString:@"purple"])
        {
            color = [[UIColor alloc] initWithRed:.5 green:0 blue:.5 alpha:alpha];
        }
    }
    
    return color;
}

@end
