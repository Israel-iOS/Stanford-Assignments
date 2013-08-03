//
//  CardGameViewController.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "FlipResultView.h"
#import "MatchCollectionViewCell.h"

@interface CardGameViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
@property (weak, nonatomic) IBOutlet FlipResultView *flipResultView;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Deck *deck;

@end

@implementation CardGameViewController

#pragma Properties

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:self.deck];
        _game.numberOfCardsToMatch = self.numberOfCardsToMatch;
        _game.matchBonusMultiplier = self.matchBonusMultiplier;
        _game.mismatchPenalty = self.mismatchPenalty;
        _game.flipCost = self.flipCost;
        _game.gameName = self.identifier;
    }
    
    return _game;
}

// Calls createDeck, an abstract method that's overridden by subclass controllers, to get the right type of deck
- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

#pragma UICollectionViewDataSource protocol methods

#define CARD_SECTION_INDEX 0
#define MATCH_SECTION_INDEX 1

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == CARD_SECTION_INDEX) return [self.game cardsInPlayCount];
    
    else if (section == MATCH_SECTION_INDEX) return [self.game matchesCount];
    
    return 0;
}

// Updates the collection view cells for the card cells as well as our matched card cells
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (indexPath.section == CARD_SECTION_INDEX)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell withCard:card animated:NO];
    }
    else if (indexPath.section == MATCH_SECTION_INDEX)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MatchCell" forIndexPath:indexPath];
        NSArray *matchedCards = [self.game matchAtIndex:indexPath.item];
        [self updateCell:cell withMatchedCards:matchedCards];
    }
    return cell;
}

#pragma UICollectionViewDelegateFlowLayout protocol methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cardCellSize = ((UICollectionViewFlowLayout *)collectionViewLayout).itemSize;
    switch (indexPath.section)
    {
        case CARD_SECTION_INDEX:
            return cardCellSize;
            break;
            
        case MATCH_SECTION_INDEX:
            return CGSizeMake(cardCellSize.width * self.numberOfCardsToMatch * .8, cardCellSize.height * .8);
            break;
    }
    return CGSizeMake(0, 0);
}

// Sets up margin between cards and matched cards
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    if (section == CARD_SECTION_INDEX) return UIEdgeInsetsMake(0, 0, 10, 0);
    
    else return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma Abstract methods

- (void)updateCell:(UICollectionViewCell *)cell withCard:(Card *)card animated:(BOOL)animated
{
    // abstract method
}

- (void)updateCell:(UICollectionViewCell *)cell withMatchedCards:(NSArray *)cards
{
    // abstract method
}

- (Deck *)createDeck
{
    return nil; // abstract method
}

- (void)removeMatchedCardsFromGame:(CardMatchingGame *)game
{
    // abstract
}

+ (NSArray *)createCardSubviews:(NSArray *)cards
{
    // abstract
    return nil;
}

- (void)markCardInCell:(UICollectionViewCell *)cell
{
    // abstract
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        if (indexPath.section == CARD_SECTION_INDEX)
        {
            Card *card = [self.game cardAtIndex:indexPath.item];
            [self updateCell:cell withCard:card animated:NO];
        }
        else if (indexPath.section == MATCH_SECTION_INDEX)
        {
            NSArray *matchedCards = [self.game matchAtIndex:indexPath.item];
            [self updateCell:cell withMatchedCards:matchedCards];
        }
    }
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)sender
{
    CGPoint tapPoint = [sender locationInView:self.cardCollectionView];
    
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapPoint];
    
    // If the gesture was made on a cell in the collection view
    if (indexPath && indexPath.section == CARD_SECTION_INDEX)
    {
        // Flip a card
        [self.game flipCardAtIndex:indexPath.item];
        
        [self updateCell:[self.cardCollectionView cellForItemAtIndexPath:indexPath] withCard:[self.game cardAtIndex:indexPath.item] animated:YES];
        
        // Display the result in the flip result view (if one exists)
        if (self.game.result)
        {
            [self.flipResultView displayResultString:self.game.result withCardSubviews:[[self class]createCardSubviews:[self.game cardsFromResult]] displayRatio:self.cardSubviewDisplayRatio];
        }
       
        // Remove matched (i.e. unplayable) cards
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        
        NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
        
        for (int i = 0; i < [self.cardCollectionView numberOfItemsInSection:0]; i++)
        {
            if ([[self.game cardAtIndex:i] isUnplayable])
            {
                [mutableArray addObject:[NSIndexPath indexPathForItem:i inSection:CARD_SECTION_INDEX]];
                [mutableIndexSet addIndex:i];
            }
        }
        if ([mutableIndexSet count])      
        {
            double delayInSeconds = 1;
            // Update matched section of our collection view
            [self.cardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.game matchesCount]-1 inSection:MATCH_SECTION_INDEX]]];
            // Finally, remove the cards from the game and from the collection view. This has to be done after we insert the matched cards into the match section of the collection view, otherwise there's a discrepancy between what the data source returns for the card count vs. the cell count in the collection view.
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                 [self.game removeCardsAtIndexes:mutableIndexSet];
                 [self.cardCollectionView deleteItemsAtIndexPaths:[mutableArray copy]];
                
            });
        }

       // self.flipCount++;
        [self updateUI];
    }
}

- (IBAction)deal
{
        UIAlertView *newGameWarning = [[UIAlertView alloc] initWithTitle:@"Start New Game"
                                                                 message:@"Are you sure you want to start over?"
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                       otherButtonTitles:@"Ok", nil];
        
            [newGameWarning show];
        
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else
    {
        [self createNewGame];
    }
}

- (void)createNewGame
{
    self.game = nil;
    self.deck = nil;
    self.addCardsButton.enabled = YES;
    self.addCardsButton.alpha = 1;
    [self.flipResultView displayResultString:@""];
    // This will force a resync to the model data and is needed to force the cardCollectionView to reload the correct number of cells, since they may have been added/deleted during the previous game
    [self.cardCollectionView reloadData];
    [self updateUI];
    
    }

- (IBAction)addCards:(id)sender
{
    // Penalize the player if a match exists
    NSIndexSet *indexSet = [self.game findMatch];
    if ([indexSet count])
    {
        [self.game addPenalty:self.mismatchPenalty*2];
        [self.flipResultView displayResultString:[NSString stringWithFormat:@"Missed a match! -%d point penalty", self.mismatchPenalty*2]];
    }
    
    // Add cards from deck, if available
    if ([self.game hasDrawableCards]) {
        for (int i = 0; i < self.numberOfCardsToAdd; i++)
        {
            Card *card = [self.game drawCardFromDeck];
            if (card)
            {
                [self.cardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.game cardsInPlayCount]-1
                                                                                       inSection:CARD_SECTION_INDEX]]];
            }
        }
        
        [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.game cardsInPlayCount]-1
                                                                             inSection:CARD_SECTION_INDEX]
                                        atScrollPosition:UICollectionViewScrollPositionBottom
                                                animated:YES];
    }
    else
    {
        // No more available cards in deck, so disable button
        self.addCardsButton.enabled = NO;
        self.addCardsButton.alpha = .3;
        
        // Check if game has ended (no more matches)
        indexSet = [self.game findMatch];
        if (![indexSet count])
        {
            [self.flipResultView displayResultString:@"Game over, man!"];
        }
    }
}

- (IBAction)findMatch
{
        // Query the game for a match
    NSIndexSet *indexSet = [self.game findMatch];
    
    if ([indexSet count])
    {
        NSUInteger index = [indexSet firstIndex];
        
        // Mark the match cells
        while (index != NSNotFound)
        {
            UICollectionViewCell *cell = nil;
            cell = [self.cardCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:CARD_SECTION_INDEX]];
            
            // Add visual decoration to the cell to give a visual hint that it is part of a match
            [self markCardInCell:cell];
            index = [indexSet indexGreaterThanIndex: index];
        }
        
        // And penalize the player for the hint
        [self.game addPenalty:self.mismatchPenalty * 2];
        [self.flipResultView displayResultString:[NSString stringWithFormat:@"Here's a hint!"]];
        [self updateUI];
    }
    else
    {
        [self.flipResultView displayResultString:@"No match found"];
    }
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    self.flipResultView.backgroundColor = [UIColor underPageBackgroundColor];
    [self.cardCollectionView registerClass:[MatchCollectionViewCell class] forCellWithReuseIdentifier:@"MatchCell"];
}

@end