//
//  FlickrPhotoCache.m
//  Assignment6
//
//  Created by Apple on 06/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "FlickrPhotoCache.h"

#define IMAGE_CACHE @"ImageCache"

@interface FlickrPhotoCache()

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation FlickrPhotoCache


- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.images = [[NSMutableArray alloc] init];
        NSFileManager *fileMgr = [[NSFileManager alloc] init];
        NSURL *cacheURL = [[fileMgr URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *imageCachePath = [cacheURL.path stringByAppendingPathComponent:IMAGE_CACHE];
        BOOL isDir, isExist;
        
        isExist = [fileMgr fileExistsAtPath:imageCachePath isDirectory:&isDir];
        
        if (!isExist || !isDir)
        {
            [fileMgr createDirectoryAtPath:imageCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else
        {
            NSDirectoryEnumerator *directoryEnumerator = [fileMgr enumeratorAtPath:imageCachePath];
            NSString *fileName;
            while((fileName = [directoryEnumerator nextObject]))
            {
                NSDictionary *attr = [fileMgr attributesOfItemAtPath:[imageCachePath stringByAppendingPathComponent:fileName] error:nil];
                //NSLog(@"%@: %@",fileName,attr);
                NSDictionary *file = [NSDictionary dictionaryWithObjectsAndKeys:fileName,@"name", [attr valueForKey:@"NSFileCreationDate"],@"date",[attr valueForKey:@"NSFileSize"],@"size",nil];
                [self.images addObject:file];
            }
            [self.images sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
            //NSLog(@"%@", self.images);
        }
    }
    
    return self;
}

- (NSDictionary *)findFileWithIdentifier:(NSString *)identifier
{
    for(NSDictionary *file in self.images)
    {
        if([[file valueForKey:@"name"] isEqual:identifier])
        {
            return file;
        }
    }
    
    return nil;
}

- (void)updateCache
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSString *imageFilePath;
    NSDictionary *file;
    NSInteger size = 0;
    //NSLog(@"print size");
    for(NSDictionary *file in self.images)
    {
        size += [[file valueForKey:@"size"] integerValue];
        //NSLog(@"size=%d", size);
    }
    
    while(size > 10*1024*1024)
    {
        file = [self.images lastObject];
        size -= [[file objectForKey:@"size"] integerValue];
        NSURL *cacheURL = [[fileMgr URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        imageFilePath = [[cacheURL.path stringByAppendingPathComponent:IMAGE_CACHE] stringByAppendingPathComponent:[file valueForKey:@"name"]];
        [fileMgr removeItemAtPath:imageFilePath error:nil];
        [self.images removeLastObject];
        NSLog(@"delete %@, total size=%d", [file valueForKey:@"name"], size);
    }
}

- (void)addImageToCache:(UIImage *)image withIdentifier:(NSString *)identifier
{
    if(![self findFileWithIdentifier:identifier])
    {
        NSFileManager *fileMgr = [[NSFileManager alloc] init];
        NSURL *cacheURL = [[fileMgr URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *imageFilePath = [[cacheURL.path stringByAppendingPathComponent:IMAGE_CACHE] stringByAppendingPathComponent:identifier];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        [fileMgr createFileAtPath:imageFilePath contents:imageData attributes:nil];
        
        NSDictionary *attr = [fileMgr attributesOfItemAtPath:imageFilePath error:nil];
        NSDictionary *file = [NSDictionary dictionaryWithObjectsAndKeys:identifier,@"name", [attr valueForKey:@"NSFileCreationDate"],@"date",[attr valueForKey:@"NSFileSize"],@"size",nil];
        [self.images addObject:file];
        [self.images sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
        [self updateCache];
    }
}

- (UIImage *)getImageFromCacheWithIdentifier:(NSString *)identifier
{
    UIImage *image;
    NSDictionary *file = [self findFileWithIdentifier:identifier];
    if(file)
    {
        NSFileManager *fileMgr = [[NSFileManager alloc] init];
        NSURL *cacheURL = [[fileMgr URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *imageFilePath = [[cacheURL.path stringByAppendingPathComponent:IMAGE_CACHE] stringByAppendingPathComponent:identifier];
        image = [UIImage imageWithData:[fileMgr contentsAtPath:imageFilePath]];
    }
    
    return image;
}

@end
