//
//  GameSettingsViewController.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "GameSettingsViewController.h"
#import "GameSettings.h"

@interface GameSettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *playingCardStartCountLabel;
@property (weak, nonatomic) IBOutlet UISlider *playingCardStartCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@end

@implementation GameSettingsViewController

- (void)updatePlayingCardStartCountLabelWithCount:(NSUInteger)count
{
    self.playingCardStartCountLabel.text = [NSString stringWithFormat:@"Playing Card Start Count: %d", count];
}

// Updates label when user moves slider
- (IBAction)changePlayingCardStartCount:(UISlider *)sender
{
    int count = round(sender.value);
    [self updatePlayingCardStartCountLabelWithCount:count];
}

// Updates the actual game setting when user is done moving slider. We separate this into its own target-action method because we don't want to constantly update the game settings value when we scrub the slider, which would cause a synchronization with the user defaults each time. Instead, we choose to synchronize only when the user does a touch up (either inside or outside the UIControl)
- (IBAction)editedPlayingCardStartCount:(UISlider *)sender
{
    int count = round(sender.value);
    [GameSettings settings].playingCardStartCount = count;
}

- (void)setup
{
    // Update our UI with items from game settings
    GameSettings *gameSettings = [GameSettings settings];
    self.playingCardStartCountSlider.value = gameSettings.playingCardStartCount;
    [self updatePlayingCardStartCountLabelWithCount:gameSettings.playingCardStartCount];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    [self engraveLabel:self.displayLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)engraveLabel:(UILabel *)label
{
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
}

@end
