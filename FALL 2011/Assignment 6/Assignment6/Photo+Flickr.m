//
//  Photo+Flickr.m
//  Assignment6
//
//  Created by Apple on 11/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "Photo+Flickr.h"
#import "Place+Create.h"
#import "Tag+Create.h"
#import "FlickrFetcher.h"
#import "FlickrHelper.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1))
    {
        // handle error
    }
    else if ([matches count] == 0)
    {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.data = [NSKeyedArchiver archivedDataWithRootObject:flickrInfo];
        photo.place = [Place placeWithName:[flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME] inManagedObjectContext:context];
        
        NSMutableSet *tags = [[NSMutableSet alloc] init];
        for(NSString *tagName in [FlickrHelper getTagsForPhoto:flickrInfo])
        {
            Tag *tag = [Tag tagWithName:tagName inManagedObjectContext:context];
            tag.count++;
            [tags addObject:tag];
        }
        photo.tags = tags;
        
    }
    else
    {
        photo = [matches lastObject];
    }
    
    return photo;
}

+ (Photo *)getPhotoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1))
    {
        // handle error
    }
    else if ([matches count] == 1)
    {
        photo = [matches lastObject];
    }
    
    return photo;
}

- (void)prepareForDeletion
{
    Place *place = self.place;
    if ([place.photos count] == 1)
    {
        [self.managedObjectContext deleteObject:place];
    }
    
    NSSet *tags = self.tags;
    for (Tag *tag in tags)
    {
        tag.count--;
        if ([tag.photos count] == 1)
        {
            [self.managedObjectContext deleteObject:tag];
        }
    }
}

/*
 +(void)deletePhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context
 {
 Place *place = photo.place;
 
 if ([place.photos count] == 1)
 {
 [context deleteObject:place];
 }
 [context deleteObject:photo];
 }
 */

@end
