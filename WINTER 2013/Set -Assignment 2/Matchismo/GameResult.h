//
//  GameResult.h
//  Matchismo
//
//  Created by Apple on 05/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) NSInteger score;
@property (strong, nonatomic) NSString *gameName;

+ (void)clearAllGameScores;
+ (NSArray *)allResults;

- (void)synchronize;
- (id)initFromPropertyList:(id)plist;
- (id)initWithGameName:(NSString *)name;

- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult;



@end
