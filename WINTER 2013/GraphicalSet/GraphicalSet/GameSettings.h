//
//  GameSettings.h
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

@property (nonatomic) NSUInteger playingCardStartCount;

+ (GameSettings *)settings;

@end
