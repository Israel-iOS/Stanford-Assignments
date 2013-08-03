//
//  RecentsTableViewController.m
//  Assignment-4
//
//  Created by Apple on 20/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosInPlaceTableViewController.h"
#import "TopPlacesMapViewController.h"
#import "PhotoViewController.h"
#import "FlickrPhotosInPlaceAnnotation.h"

@interface RecentsTableViewController ()

@end

@implementation RecentsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.picturesData = [defaults objectForKey:@"FlickrFetcherRecentPictures"];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.picturesData = [defaults objectForKey:@"FlickrFetcherRecentPictures"];
    [self.tableView reloadData];
}

@end