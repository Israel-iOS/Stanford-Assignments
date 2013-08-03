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
#import "RecentsUserDefaults.h"

@interface PhotosInPlaceTableViewController ()

@end

@implementation PhotosInPlaceTableViewController

- (IBAction)refresh:(id)sender
{
   // NSLog(@"%@",[FlickrFetcher photosInPlace:self.place maxResults:50]);//to check the contents of photos list in a selected place
    //spinner when downloading
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue,
    ^{
        NSArray *photos = [FlickrFetcher photosInPlace:self.place maxResults:50];
        dispatch_async(dispatch_get_main_queue(),
        ^{
            self.navigationItem.rightBarButtonItem = sender;
            self.photos = photos;
        });
    });
    dispatch_release(downloadQueue);
}

- (void)setPhotos:(NSArray *)photos
{
    if (_photos!=photos)
    {
        _photos=photos;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the city name in navigation bar
    NSString *cityName = [self.place objectForKey:FLICKR_PLACE_NAME];
    self.navigationItem.title = cityName;
    
    //refresh automatically
    [self refresh:self.navigationItem.rightBarButtonItem];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    [RecentsUserDefaults saveRecentsUserDefaults:photo];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
