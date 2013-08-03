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
#import "RecentsUserDefaults.h"
#import "PhotoViewController.h"

@interface RecentsTableViewController ()

@end

@implementation RecentsTableViewController

- (void)setPhotos:(NSArray *)photos
{
    if (_photos!=photos)
    {
        _photos = photos;
        [self.tableView reloadData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.photos = [RecentsUserDefaults retrieveRecentsUserDefaults]; //if put in viewDidLoad, it only get called once after launching app
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RecentPhoto Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    NSString *photoTitle = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *photoDescription = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    if ([photoTitle length]==0 && [photoDescription length]!=0)
    {
        photoTitle = photoDescription;
        photoDescription = nil;
    }
    if ([photoTitle length]==0 && [photoDescription length]==0)
    {
        photoTitle = @"Unknown";
    }
    cell.textLabel.text = photoTitle;
    cell.detailTextLabel.text = photoDescription;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSDictionary *photo = [self.photos objectAtIndex:path.row];
    [segue.destinationViewController setPhoto:photo];
}

@end