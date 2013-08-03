//
//  PhotosInPlaceTableViewController.m
//  Assignment-4
//
//  Created by Apple on 20/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "PhotosInPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"
#import "TopPlacesMapViewController.h"
#import "FlickrPhotosInPlaceAnnotation.h"

@interface PhotosInPlaceTableViewController ()

@end

@implementation PhotosInPlaceTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *oldbutton = self.navigationItem.rightBarButtonItem;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
    //use GCD to load data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        NSArray *photos = [FlickrFetcher photosInPlace:self.place maxResults:50];
                       
        dispatch_async(dispatch_get_main_queue(),
            ^{
            self.picturesData = photos;
            [spinner stopAnimating];
            self.navigationItem.rightBarButtonItem = oldbutton;
              });
    });
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSDictionary *selectedPic = [self.picturesData objectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recent = [[defaults objectForKey:@"FlickrFetcherRecentPictures"] mutableCopy];
    
    //make sure it isn't already in there
    if(recent)
    {
        for(NSDictionary *pic in recent)
        {
            if([pic objectForKey:@"id"] == [selectedPic objectForKey:@"id"]) return;
        }
    }
    
    //create a new recent list with the selected one on top
    NSMutableArray *newRecent = [[NSMutableArray alloc] initWithObjects:selectedPic, nil];
    if(recent)
    {
        [newRecent addObjectsFromArray:recent];
    }
    
    //trim to only 20 pictures
    if(newRecent.count > 20)
    {
        [newRecent removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(20, (newRecent.count-20))]];
    }
    
    [defaults setObject:[newRecent copy] forKey:@"FlickrFetcherRecentPictures"];
}

@end