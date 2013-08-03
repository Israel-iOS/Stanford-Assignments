//
//  PlayingCardGameViewController.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"
#import "MatchCollectionViewCell.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (NSString *)identifier
{
    return @"PlayingCard";
}

- (NSUInteger)startingCardCount
{
    return [GameSettings settings].playingCardStartCount;
}

- (NSUInteger)numberOfCardsToMatch
{
    return 2;
}

-(CGFloat)matchBonusMultiplier
{
    return 3;
}

- (int)mismatchPenalty
{
    return 2;
}

- (int)flipCost
{
    return 1;
}

- (CGFloat)cardSubviewDisplayRatio
{
    return .8;
}

// Overrides abstract method in superclass
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

// Implements/overrides the superclass method
- (void)updateCell:(UICollectionViewCell *)cell
          withCard:(Card *)card
          animated:(BOOL)animated
{
    PlayingCard *playingCard = (PlayingCard *)card;
    
    if (playingCard)
    {
        PlayingCardCollectionViewCell *pccvc = (PlayingCardCollectionViewCell *)cell;
        
        if (pccvc)
        {
            pccvc.playingCardView.rank = playingCard.rank;
            pccvc.playingCardView.suit = playingCard.suit;
            if (animated)
            {
                [UIView transitionWithView:pccvc.playingCardView
                                  duration:.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    pccvc.playingCardView.faceUp = playingCard.isFaceUp;
                                } completion:NULL];
            }
            else
            {
                pccvc.playingCardView.faceUp = playingCard.isFaceUp;
            }
        }
    }
}

- (void)updateCell:(UICollectionViewCell *)cell withMatchedCards:(NSArray *)cards
{
    if ([cards count] == 2)
    {
        MatchCollectionViewCell *mcvc = (MatchCollectionViewCell *)cell;
        
        if (mcvc)
        {
            PlayingCardView *playingCardView1 = [[PlayingCardView alloc] init];
            PlayingCardView *playingCardView2 = [[PlayingCardView alloc] init];
            playingCardView1.backgroundColor = [UIColor clearColor];
            playingCardView2.backgroundColor = [UIColor clearColor];
            PlayingCard *playingCard1 = (PlayingCard *)cards[0];
            PlayingCard *playingCard2 = (PlayingCard *)cards[1];
            
            if (playingCard1 && playingCard2) {
                playingCardView1.rank = playingCard1.rank;
                playingCardView1.suit = playingCard1.suit;
                playingCardView1.faceUp = YES;
                playingCardView2.rank = playingCard2.rank;
                playingCardView2.suit = playingCard2.suit;
                playingCardView2.faceUp = YES;
                
                [mcvc setCardView:playingCardView1 atPosition:0];
                [mcvc setCardView:playingCardView2 atPosition:1];
                mcvc.opaque = NO;
            }
        }
    }
}

// Accepts array of Card, returns array of UIView
+ (NSArray *)createCardSubviews:(NSArray *)cards
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (Card *card in cards)
    {
        if ([card isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            PlayingCardView *view = [[PlayingCardView alloc] init];
            view.rank = playingCard.rank;
            view.suit = playingCard.suit;
            view.faceUp = YES;
            [mutableArray addObject:view];
        }
    }
    
    return [mutableArray copy];
}

@end