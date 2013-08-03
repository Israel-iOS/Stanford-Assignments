//
//  GameSettings.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

#define GAME_SETTINGS_KEY @"GameSettings_All"
#define PLAYING_CARD_START_COUNT_KEY @"PlayingCardStartCount"

@synthesize playingCardStartCount = _playingCardStartCount;

- (NSUInteger)playingCardStartCount
{
    if (_playingCardStartCount == 0)
    {
        _playingCardStartCount = 22;
    }
    
    return _playingCardStartCount;
}

- (void)setPlayingCardStartCount:(NSUInteger)playingCardStartCount
{
    _playingCardStartCount = playingCardStartCount;
    
    [self synchronize];
}

- (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] setObject:[self asPropertyList] forKey:GAME_SETTINGS_KEY];
}

- (NSDictionary *)asPropertyList
{
    return @{ PLAYING_CARD_START_COUNT_KEY : @(self.playingCardStartCount) };
}

// Get game settings singleton
+ (GameSettings *)settings
{
    static GameSettings *gameSettings;
    if (!gameSettings)
    {
        gameSettings = [[self alloc] init];
        if (gameSettings)
        {
            NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:GAME_SETTINGS_KEY];
            if (dictionary)
            {
                gameSettings.playingCardStartCount = [dictionary[PLAYING_CARD_START_COUNT_KEY] intValue];
            }
        }
    }
    
    return gameSettings;
}

@end
