//
//  CardGameViewController.h
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "GameSettings.h"

@interface CardGameViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSString *identifier; // abstract
@property (nonatomic) NSUInteger startingCardCount; // abstract
@property (nonatomic) NSUInteger numberOfCardsToMatch; // abstract
@property (nonatomic) NSUInteger numberOfCardsToAdd; // abstract
@property (nonatomic) CGFloat matchBonusMultiplier; // abstract
@property (nonatomic) int mismatchPenalty; // abstract
@property (nonatomic) int flipCost; // abstract
@property (nonatomic) CGFloat cardSubviewDisplayRatio; // abstract

- (Deck *)createDeck; // abstract

- (void)updateCell:(UICollectionViewCell *)cell
          withCard:(Card *)card
          animated:(BOOL)animated; // abstract

- (void)updateCell:(UICollectionViewCell *)cell
  withMatchedCards:(NSArray *)cards; // abstract

- (void)markCardInCell:(UICollectionViewCell *)cell; // abstract

+ (NSArray *)createCardSubviews:(NSArray *)cards; // abstract, accepts array of Card, returns array of UIView

@end