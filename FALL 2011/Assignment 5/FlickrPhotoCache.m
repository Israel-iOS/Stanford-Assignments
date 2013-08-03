//
//  FlickrPhotoCache.m
//  Assignment5
//
//  Created by Apple on 24/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "FlickrPhotoCache.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoCache()

@property (nonatomic, strong) NSArray *photoCachePaths;//photo id + jpg or png as the file name;
@property (nonatomic, strong) NSString *flickrCacheDir; //path to the cache directory

@end

@implementation FlickrPhotoCache

#define FLICKR_CACHE_DIR @"Flickr"
#define CACHE_MAX_SIZE  10000000

- (void)retrievePhotoCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths objectAtIndex:0];
    //NSLog(@"paths is %@",paths);
    //NSLog(@"cacheDir is %@",cacheDir);
    
    NSString *flickrCacheDir = [NSString stringWithFormat:@"%@/%@", cacheDir, FLICKR_CACHE_DIR];
    self.flickrCacheDir = flickrCacheDir;
    if (![fileManager contentsOfDirectoryAtPath:self.flickrCacheDir error:nil])
    { //check if dir exists
        // NSLog(@"No flickr cache directory found");
        //create a dir
        [fileManager createDirectoryAtPath:self.flickrCacheDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    //if ([fileManager contentsOfDirectoryAtPath:flickrCacheDir error:nil])
    //NSLog(@"Flickr cache directory created");
    self.photoCachePaths = [fileManager contentsOfDirectoryAtPath:self.flickrCacheDir error:nil];
    
    //keep cache folder less than 10MB
    NSDate *earlistDate;
    NSString *pathToDelete;
    double folderSize = 0;
    for (NSString *photoCachePath in self.photoCachePaths){
        NSString *path = [NSString stringWithFormat:@"%@/%@", self.flickrCacheDir,photoCachePath];
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
        NSDate *date = [fileAttributes fileCreationDate];
        double fileSize = [fileAttributes fileSize];
        folderSize +=fileSize;
        if (!earlistDate)
        {
            earlistDate = date;
            pathToDelete = path;
        }
        else
        {
            if ([date compare:earlistDate] == NSOrderedAscending)
            {
                earlistDate = date;
                pathToDelete = path;
            }
            //NSLog(@"file: %@, creation date:%@",photoCachePath,date);
        }
        
    }
    //NSLog(@"folderSize is %g",folderSize);
    if (folderSize > CACHE_MAX_SIZE) [fileManager removeItemAtPath:pathToDelete error:nil];
    //NSLog(@"earlistDate is %@, pathToDelete is %@",earlistDate,pathToDelete);
}

- (BOOL)isInCache:(NSDictionary *)photo
{
    BOOL result = NO;
    for (NSString *photoCachePath in self.photoCachePaths)
    {
        NSString *photoID = [photo objectForKey:FLICKR_PHOTO_ID];
        NSString *fileFullName = [[photoCachePath componentsSeparatedByString:@"/"] lastObject];
        NSString *fileName = [[fileFullName componentsSeparatedByString:@"."] objectAtIndex:0];
        if ([fileName isEqualToString:photoID]) result = YES;
        //NSLog(@"fileName is %@, photoID is %@",fileName,photoID);
    }
    return result;
}

-(NSString *)readImageFromCache:(NSDictionary *)photo
{
    NSString *result;
    for (NSString *photoCachePath in self.photoCachePaths)
    {
        NSString *photoID = [photo objectForKey:FLICKR_PHOTO_ID];
        NSString *fileFullName = [[photoCachePath componentsSeparatedByString:@"/"] lastObject];
        NSString *fileName = [[fileFullName componentsSeparatedByString:@"."] objectAtIndex:0];
        if ([fileName isEqualToString:photoID])
            result = [NSString stringWithFormat:@"%@/%@",self.flickrCacheDir,fileFullName];
    }
    return result;
}

- (void)writeImageToCache:(UIImage *)image forPhoto:(NSDictionary *)photo fromUrl:(NSURL *)url
{
    NSString *photoID = [photo objectForKey:FLICKR_PHOTO_ID];
    NSString *urlString = [url absoluteString];
    NSString *photoFormat = [[[urlString componentsSeparatedByString:@"."] lastObject] lowercaseString];
    
    NSString *fileFullName = [NSString stringWithFormat:@"%@.%@",photoID,photoFormat];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.flickrCacheDir,fileFullName];
    if ([photoFormat isEqualToString:@"jpg"])
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:path atomically:YES];
    }
    if ([photoFormat isEqualToString:@"png"])
    {
        [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    }
    NSLog(@"last photo in cache is %@",[self.photoCachePaths lastObject]);
}

@end
