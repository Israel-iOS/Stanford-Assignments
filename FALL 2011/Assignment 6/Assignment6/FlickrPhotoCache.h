//
//  FlickrPhotoCache.h
//  Assignment6
//
//  Created by Apple on 06/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrPhotoCache : NSObject

- (void)addImageToCache:(UIImage *)image withIdentifier:(NSString *)identifier;

- (UIImage *)getImageFromCacheWithIdentifier:(NSString *)identifier;

@end

