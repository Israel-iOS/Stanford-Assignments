//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Apple on 24/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDesk.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameLogicController;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;

- (IBAction)gameModeChanged:(UISegmentedControl *)sender;
- (IBAction)historySliderChanged:(UISlider *)sender;
- (IBAction)deal:(UIButton *)sender;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDesk alloc] init]];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    // make sure the UI matches the model. Also possibly send info to model
    
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.unplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        
        if (!card.isFaceUp)
        {
            UIImage *cardBackImage = [UIImage imageNamed:@"avatar_id40309.jpg"];
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
            cardButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        }
        else
        {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }      
    }
    
    // Display flip result
    self.flipResultLabel.alpha = 1.0;
    self.flipResultLabel.text = [self.game flipResult];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    // Label Slider
    self.historySlider.maximumValue = [self.game.flipHistory count]-1;
    [self.historySlider setValue:self.historySlider.maximumValue];
    
    [self updateGameLogicSetting];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
  //  NSLog(@"flip count updated to %d", self.flipCount);
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
   
    self.flipCount++;
    self.gameLogicController.enabled = NO;
 
    [UIView transitionWithView:sender duration:0.2 options: UIViewAnimationOptionTransitionFlipFromRight animations:^{ sender.highlighted = YES;} completion:nil];
        
    [self updateUI];
}

- (IBAction)deal:(UIButton *)sender
{
    self.game = nil;
    self.flipCount = 0;
    self.gameLogicController.enabled = YES;
    [self.game reset];
    [self updateUI];
    self.flipResultLabel.text = [NSString stringWithFormat:@"Remember: flipping up a card costs 1 point..."]; // Override game message
}

- (IBAction)historySliderChanged:(UISlider *)sender
{
    self.flipResultLabel.text = [self.game.flipHistory objectAtIndex:(int)sender.value];
    self.flipResultLabel.alpha = 0.3;
}

-(void)updateGameLogicSetting
{
    if (self.gameLogicController.selectedSegmentIndex == 0)
    {
        self.game.match3mode = NO;
    }
    else
    {
        self.game.match3mode = YES;
    }
}

- (IBAction)gameModeChanged:(UISegmentedControl *)sender
{
    [self updateGameLogicSetting];
}

@end