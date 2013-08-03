//
//  CardGameSettings.m
//  Matchismo
//
//  Created by Apple on 04/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "CardGameSettings.h"

@implementation CardGameSettings

#define CardGameSettingsStoreKey @"MatchismoCardGameSettingsStore"

+ (NSMutableDictionary *)allSettings
{
    static NSMutableDictionary* _allSettings = nil;
    if (!_allSettings)
    {
        _allSettings = [self loadSettingsFromStore];
    }
    
    return _allSettings;
}


+ (id)valueForKey:(NSString *)key
{
    return [[self allSettings] valueForKey:key];
}


+ (void)setValue:(id)value forKey:(NSString *)key
{
    [self allSettings][key] = value;
    [self synchronize];
}

+ (NSMutableDictionary *)loadSettingsFromStore
{
    NSMutableDictionary *allSettings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:CardGameSettingsStoreKey] mutableCopy];
    
    if (!allSettings)
    {
        allSettings = [[NSMutableDictionary alloc] init];
    }
    
    return allSettings;
}

+ (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] setObject:[self allSettings] forKey:CardGameSettingsStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)integerValueForKey:(NSString *)key
{
    int integerValue = 0;
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        NSNumber *numberValue = (NSNumber *)value;
        integerValue = [numberValue intValue];
    }
    
    return integerValue;
}

@end
