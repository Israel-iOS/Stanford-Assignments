//
//  FlickrHelper.h
//  Assignment6
//
//  Created by Apple on 06/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrHelper : NSObject

+(NSDictionary *)getInfoForPhoto:(NSDictionary *)photo;
+(NSDictionary *)getInfoForPlace:(NSDictionary *)place;
+(NSArray *)getTagsForPhoto:(NSDictionary *)photo;

@end
