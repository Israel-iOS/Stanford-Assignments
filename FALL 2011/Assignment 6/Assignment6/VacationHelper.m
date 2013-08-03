//
//  VacationHelper.m
//  Assignment6
//
//  Created by Apple on 05/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VacationHelper.h"

#define VACATIONS_PATH @"Vacations"


static NSMutableDictionary *vacationsForName;

@implementation VacationHelper

+ (NSArray *)getVacationNames
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
   
    NSURL *dirURL = [[[fileMgr URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:VACATIONS_PATH];
    
    NSArray *urls = [fileMgr contentsOfDirectoryAtURL:dirURL includingPropertiesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] options:0  error:0];
    
    NSMutableArray *vacationNames = [[NSMutableArray alloc] init];
    for (NSURL *url in urls)
    {
        [vacationNames addObject:[url lastPathComponent]];
    }
    return vacationNames;
}

+ (void)addVacation:(UIManagedDocument *)vacation withName:(NSString *)vacationName
{
    if(!vacationsForName)
    {
        vacationsForName = [[NSMutableDictionary alloc] init];
    }
    
    [vacationsForName setObject:vacation forKey:vacationName];
}

+ (void)openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    UIManagedDocument *vacation = [vacationsForName objectForKey:vacationName];
    NSURL *dirURL = [[[fileMgr URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:VACATIONS_PATH];
    
    if(!vacation)
    {
        vacation = [[UIManagedDocument alloc] initWithFileURL:[dirURL URLByAppendingPathComponent:vacationName]];
        [self addVacation:vacation withName:vacationName];
    }
    
    if (![fileMgr fileExistsAtPath:[vacation.fileURL path]])
    {
        BOOL isDir, isExist;
        isExist = [fileMgr fileExistsAtPath:[dirURL path] isDirectory:&isDir];
        if(!isDir || !isExist)
        {
            [fileMgr createDirectoryAtURL:dirURL withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if(success)
            {
                completionBlock(vacation);
            }
        }];
    }
    else if(vacation.documentState == UIDocumentStateClosed)
    {
        [vacation openWithCompletionHandler:^(BOOL success){
            if(success)
            {
                completionBlock(vacation);
            }
        }];
    }
    else if(vacation.documentState == UIDocumentStateNormal)
    {
        completionBlock(vacation);
    }
}

@end
