//
//  TopPlacesTableViewController.m
//  Assignment6
//
//  Created by Apple on 11/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrAnnotation.h"
#import "FlickrHelper.h"
#import "MapViewController.h"

@interface TopPlacesTableViewController() <MapViewControllerDelegate>

@end

@implementation TopPlacesTableViewController

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation
{
    return nil;
}

- (void)didTappedAccessoryControlOfAnnotation:(id <MKAnnotation>)annotation
{
    [self performSegueWithIdentifier:@"ShowPhotos" sender:annotation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        NSArray *places = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES]]];
        
        dispatch_async(dispatch_get_main_queue(),^{
            self.dataArray = places;
        });
    });
}

- (NSDictionary *)getInfoForRow:(NSInteger)row
{
    return [FlickrHelper getInfoForPlace:[self.dataArray objectAtIndex:row]];
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.dataArray count]];
    for (NSDictionary *place in self.dataArray)
    {
        [annotations addObject:[FlickrAnnotation annotationForPlace:place]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if([segue.identifier isEqualToString:@"ShowPhotos"])
    {
        NSDictionary *place;
        PhotosTableViewController *photosTableViewController = [segue destinationViewController];
        
        if([sender isKindOfClass:[UITableViewCell class]])
        {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            place = [self.dataArray objectAtIndex:indexPath.row];
        }
        else if([sender isKindOfClass:[FlickrAnnotation class]])
        {
            place = [sender place];
        }
        
        photosTableViewController.title = [[FlickrHelper getInfoForPlace:place] objectForKey:@"title"];
        //[flickrTableViewController.spinner startAnimating];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
        dispatch_async(downloadQueue,
        ^{
            NSArray *photos = [FlickrFetcher photosInPlace:place maxResults:50];
            
            dispatch_async(dispatch_get_main_queue(),
            ^{
                photosTableViewController.dataArray = photos;
            });
        });
        return;
    }
}

@end
