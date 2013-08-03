//
//  VacationHelper.h
//  Assignment6
//
//  Created by Apple on 05/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_VACATION_NAME @"MyVacation"

typedef void (^completion_block_t)(UIManagedDocument *vacation);

@interface VacationHelper : NSObject

+ (void)openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock;

+ (NSArray *)getVacationNames;

@end
