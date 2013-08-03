//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Apple on 24/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Deck *deck;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) NSMutableArray *flipHistory;

- (IBAction)historySliderChanged:(UISlider *)sender;
- (IBAction)deal:(UIButton *)sender;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:self.deck];
        _game.matchBonusMultiplier = self.matchBonusMultiplier;
        _game.mismatchPenalty = self.mismatchPenalty;
        _game.flipCost = self.flipCost;
        _game.gameName = self.gameName;
        _game.numberOfCardsToMatch = self.numberOfCardsToMatch;
    }
    
    return _game;
}

- (Deck *)createDeck
{
    return nil; // abstract method
}

- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory) _flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [self updateButton:cardButton withCard:card];
    }
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
    [self updateResultLabel:self.flipResultLabel
                 withObject:[self formatResult:self.game.result
                                      forCards:self.game.cardsFromResult]];
    self.flipResultLabel.alpha = 1;
    self.historySlider.maximumValue = self.flipHistory.count;
    self.historySlider.value = self.historySlider.maximumValue;
}

// Abstract method -- Updates a card button with a card. This allows updateUI method to delegate responsibility of updating the card buttons to the subclasses, which is necessary since we cannot access any class more specific than Card (but can in the subclasses of this controller class)
- (void)updateButton:(UIButton *)button withCard:(Card *)card
{
}

// Abstract method -- Updates the result label with an object that represents a given result from our card matching game. We put this into its own method so that subclasses can provide class-specific formatting to the result label, e.g. using attributed strings. Note that the UILabel is passed in as the parameter; this is because we need access to it, and the only other way would be if we made the UILabel outlet public.
- (void)updateResultLabel:(UILabel *)label withObject:(id)object
{
}

// Optionally overridden by subclasses, in case they want to perform additional processing (i.e. transform game.result into an attributed string)
- (id)formatResult:(NSString *)result
          forCards:(NSArray *)cards
{
    return result;
}

- (void)toggleFlipHistorySlider:(BOOL)enabled
{
    self.historySlider.enabled = enabled;
    self.historySlider.alpha = enabled ? 1 : .3;
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self.flipHistory addObject:[self formatResult:self.game.result
                                          forCards:self.game.cardsFromResult]];
   
    self.flipCount++;
    
    [self toggleFlipHistorySlider:YES];
 
    [UIView transitionWithView:sender duration:0.2 options: UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{ sender.highlighted = YES;} completion:nil];
        
    [self updateUI];
}

- (IBAction)deal:(UIButton *)sender
{
  
    if (self.flipCount > 0)
    {
        UIAlertView *newGameWarning = [[UIAlertView alloc] initWithTitle:@"Start New Game"
                                                                 message:@"Are you sure you want to start over?"
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                       otherButtonTitles:@"Ok", nil];
        [newGameWarning show];

    }
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
    [self toggleFlipHistorySlider:NO];
    self.flipHistory = nil;
    [self updateUI];
    self.game = nil;
    self.deck = nil;
    
    self.flipCount = 0;
    [self updateUI];
    
    self.flipResultLabel.text = [NSString stringWithFormat:@"Remember: flipping up a card costs 1 point..."]; // Override game message
}

- (IBAction)historySliderChanged:(UISlider *)sender
{
    int selectedHistoryIndex = floor(sender.value);
    
    // Update UI as normal if the slider is at maximum value
    if (selectedHistoryIndex == sender.maximumValue)
    {
        [self updateUI];
    }
    else
    {
        self.flipResultLabel.alpha = .3;
        [self updateResultLabel:self.flipResultLabel withObject:self.flipHistory[selectedHistoryIndex]];
    }
}

@end