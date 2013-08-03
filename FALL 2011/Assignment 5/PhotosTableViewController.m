//
//  PhotosTableViewController.m
//  Assignment5
//
//  Created by Apple on 24/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"
#import "TopPlacesMapViewController.h"
#import "FlickrPhotosInPlaceAnnotation.h"

@interface PhotosTableViewController ()

@end

@implementation PhotosTableViewController

@synthesize picturesData = _picturesData;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setPicturesData:(NSArray *)data
{
    if(_picturesData != data)
    {
        _picturesData = data;
        if(self.tableView.window) [self.tableView reloadData];
    }
}

- (NSArray *)picturesData
{
    return _picturesData;
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.picturesData count]];
    for(NSDictionary *dict in self.picturesData)
    {
        [annotations addObject:[FlickrPhotosInPlaceAnnotation annotationForPhoto:dict]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"View Photo"])
    {
        PhotoViewController *dest = segue.destinationViewController;
        NSDictionary *photo = [self.picturesData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        dest.photo = photo;
        if(![[photo objectForKey:@"title"] isEqual: @""])
        {
            dest.navigationItem.title =[photo objectForKey:@"title"];
        }
        else
        {
            dest.navigationItem.title = @"Unknown";
        }
    }
    else if([[segue identifier] isEqualToString:@"View Map"])
    {
        TopPlacesMapViewController *dest = segue.destinationViewController;
        dest.annotations = [self mapAnnotations];
    }
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.picturesData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSDictionary *picInfo = [self.picturesData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = @"Unknown";
    if([picInfo objectForKey:@"title"])
    cell.textLabel.text = [picInfo objectForKey:@"title"];
    cell.detailTextLabel.text = @"Unknown";
    if([picInfo valueForKeyPath:@"description._content"])
    cell.detailTextLabel.text = [picInfo valueForKeyPath:@"description._content"];
    
    
    char* threadName = &"image downloader" [ indexPath.section] + indexPath.row;
    
    
  //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
               //    ^{
    dispatch_queue_t downlaodQueue = dispatch_queue_create(threadName, NULL);
    
    dispatch_async(downlaodQueue,
    ^{
        NSURL *photoURL = [FlickrFetcher urlForPhoto:picInfo format:FlickrPhotoFormatSquare];
        NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
        UIImage *photoImage = [UIImage imageWithData:photoData];
        
        dispatch_async(dispatch_get_main_queue(),
        ^{
            cell.imageView.image = photoImage;
        });

    });
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = [self.splitViewController.viewControllers lastObject];
    if([detail isKindOfClass:[PhotoViewController class]])
    {
        PhotoViewController *photoVC = detail;
        NSDictionary *photo = [self.picturesData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        photoVC.photo = photo;
        if(![[photo objectForKey:@"title"] isEqual: @""])
        {
            photoVC.navigationItem.title =[photo objectForKey:@"title"];
        }
        else
        {
            photoVC.navigationItem.title = @"Unknown";
        }
    }
}

@end