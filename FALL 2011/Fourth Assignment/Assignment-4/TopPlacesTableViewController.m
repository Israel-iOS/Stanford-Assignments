//
//  TopPlacesTableViewController.m
//  Assignment-4
//
//  Created by Apple on 20/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosInPlaceTableViewController.h"
#import "PhotoViewController.h"

@interface TopPlacesTableViewController ()

@end

@implementation TopPlacesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (IBAction)refresh:(id)sender
{
    //spinner when downloading
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    
    dispatch_async(downloadQueue, ^{
        NSArray *Ascending=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES]];
         NSArray *topPlaces = [FlickrFetcher topPlaces];
     
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
            self.topPlaces = [topPlaces sortedArrayUsingDescriptors:Ascending];
        });
    });
    dispatch_release(downloadQueue);
}

- (void)setTopPlaces:(NSArray *)topPlaces
{
    if(_topPlaces != topPlaces)
    {
        _topPlaces = topPlaces;
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    NSArray *Ascending=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES]];
    self.topPlaces = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:Ascending];
   [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Place Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *topPlace = [self.topPlaces objectAtIndex:indexPath.row];
    NSString *placeFullName = [topPlace objectForKey:FLICKR_PLACE_NAME];
    NSArray *placeArray = [placeFullName componentsSeparatedByString:@", "];
    
    NSString *placeCityName = [placeArray objectAtIndex:0];
    
    NSString *placeRestName = [NSString stringWithFormat:@"%@, %@",[placeArray objectAtIndex:0],[placeArray objectAtIndex:1]];
    cell.textLabel.text = placeCityName;
    cell.detailTextLabel.text = placeRestName;
    
    NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    
    cell.imageView.image = image;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSDictionary *place = [self.topPlaces objectAtIndex:path.row];
    [segue.destinationViewController setPlace:place];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
