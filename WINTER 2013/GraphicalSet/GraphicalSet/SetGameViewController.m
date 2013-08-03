//
//  SetGameViewController.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//
#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardCollectionViewCell.h"
#import "MatchCollectionViewCell.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSString *)identifier
{
    return @"SetCard";
}

- (NSUInteger)startingCardCount
{
    return 12;
}

- (NSUInteger)numberOfCardsToMatch
{
    return 3;
}

- (NSUInteger)numberOfCardsToAdd
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
    return 4;
}

- (CGFloat)cardSubviewDisplayRatio
{
    return 1;
}

- (void)updateCell:(UICollectionViewCell *)cell
          withCard:(Card *)card
          animated:(BOOL)animated
{
    if ([card isMemberOfClass:[SetCard class]])
    {
        SetCard *setCard = (SetCard *)card;
        
        if ([cell isMemberOfClass:[SetCardCollectionViewCell class]])
        {
            SetCardCollectionViewCell *sccvc = (SetCardCollectionViewCell *)cell;
            SetCardView *setCardView = sccvc.setCardView;
            
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.color = setCard.color;
            setCardView.shade = setCard.shade;
            setCardView.faceUp = setCard.faceUp;
        }
    }
}

- (void)updateCell:(UICollectionViewCell *)cell withMatchedCards:(NSArray *)cards
{
    if ([cards count] == 3 && [cell isMemberOfClass:[MatchCollectionViewCell class]])
    {
        MatchCollectionViewCell *mcvc = (MatchCollectionViewCell *)cell;
        
        SetCardView *view1 = [[SetCardView alloc] init];
        SetCardView *view2 = [[SetCardView alloc] init];
        SetCardView *view3 = [[SetCardView alloc] init];
        view1.backgroundColor = [UIColor whiteColor];
        view2.backgroundColor = [UIColor whiteColor];
        view3.backgroundColor = [UIColor whiteColor];
        SetCard *card1 = (SetCard *)cards[0];
        SetCard *card2 = (SetCard *)cards[1];
        SetCard *card3 = (SetCard *)cards[2];
        
        if (card1 && card2 && card3) {
            view1.number = card1.number;
            view1.shade = card1.shade;
            view1.symbol = card1.symbol;
            view1.color = card1.color;
            view2.number = card2.number;
            view2.shade = card2.shade;
            view2.symbol = card2.symbol;
            view2.color = card2.color;
            view3.number = card3.number;
            view3.shade = card3.shade;
            view3.symbol = card3.symbol;
            view3.color = card3.color;
            
            mcvc.opaque = NO;
            [mcvc setCardView:view1 atPosition:0];
            [mcvc setCardView:view2 atPosition:1];
            [mcvc setCardView:view3 atPosition:2];
        }
    }
}

- (void)markCardInCell:(UICollectionViewCell *)cell
{
    if ([cell isMemberOfClass:[SetCardCollectionViewCell class]])
    {
        SetCardCollectionViewCell *sccvc = (SetCardCollectionViewCell *)cell;
        [sccvc.setCardView mark];
    }
}

// Accepts array of Card, returns array of UIView
+ (NSArray *)createCardSubviews:(NSArray *)cards
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (Card *card in cards)
    {
        if ([card isKindOfClass:[SetCard class]])
        {
            SetCard *setCard = (SetCard *)card;
            SetCardView *view = [[SetCardView alloc] init];
            view.color = setCard.color;
            view.number = setCard.number;
            view.shade = setCard.shade;
            view.symbol = setCard.symbol;
            [mutableArray addObject:view];
        }
    }
    
    return [mutableArray copy];
}

@end
