//
//  RecentsUserDefaults.h
//  Assignment-4
//
//  Created by Apple on 20/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RECENTS_PHOTO_AMOUNT 20

@interface RecentsUserDefaults : NSObject

+ (NSArray *)retrieveRecentsUserDefaults;

+ (void)saveRecentsUserDefaults:(NSDictionary *)photo;

@end