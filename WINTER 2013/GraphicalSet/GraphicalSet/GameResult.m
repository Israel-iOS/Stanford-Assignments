//
//  GameResult.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "GameResult.h"

@interface GameResult ()

@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;

@end

@implementation GameResult

#define ALL_RESULTS_KEY @"GameResult_All"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define GAME_NAME_KEY @"GameName"
#define SCORE_KEY @"Score"

// Designated initializer
- (id)init
{
    self = [super init];
    
    if (self)
    {
        _start = [NSDate date];
        _end = _start;
    }
    
    return self;
}

- (id)initFromPropertyList:(id)plist
{
    self = [self init];
    
    if (self)
    {
        if ([plist isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _gameName = resultDictionary[GAME_NAME_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue]; // intValue returns the int value of an NSNumber
            if (!_start || !_end) self = nil;
        }
    }
    
    return self;
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score
{
    _end = [NSDate date];
    _score = score;
}

- (void)synchronize
{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    
    if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    
    mutableGameResultsFromUserDefaults[self.start.description] = [self asPropertyList];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
}

- (NSDictionary *)asPropertyList
{
    return @{ GAME_NAME_KEY : self.gameName, START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score) };
}

+ (NSArray *)allResults
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    
    for (id plist in [mutableGameResultsFromUserDefaults allValues])
    {
        GameResult *result = [[GameResult alloc] initFromPropertyList:plist];
        
        if (result) [mutableArray addObject:result];
    }
    
    return [mutableArray copy];
}

#pragma mark - Sorting

- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult
{
    if (self.score > otherResult.score)
    {
        return NSOrderedAscending;
    }
    else if (self.score < otherResult.score)
    {
        return NSOrderedDescending;
    }
    else
    {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult
{
    return [otherResult.end compare:self.end];
}

- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult
{
    if (self.duration > otherResult.duration)
    {
        return NSOrderedDescending;
    }
    else if (self.duration < otherResult.duration)
    {
        return NSOrderedAscending;
    }
    else
    {
        return NSOrderedSame;
    }
}

@end
