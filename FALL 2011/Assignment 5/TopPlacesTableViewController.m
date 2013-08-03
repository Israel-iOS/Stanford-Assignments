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
#import "TopPlacesMapViewController.h"
#import "FlickrTopPlaceAnnotation.h"

@interface TopPlacesTableViewController ()

@property NSArray *topPlaceData;

@end

@implementation TopPlacesTableViewController

@synthesize topPlaceData = _topPlaceData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *oldButton = self.navigationItem.rightBarButtonItem;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"_content" ascending:YES];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
    //use GCD to load data  
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        ^{
            
        NSArray *places = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
       
        dispatch_async(dispatch_get_main_queue(),
                       ^{
            self.topPlaceData = places;
            [spinner stopAnimating];
            self.navigationItem.rightBarButtonItem = oldButton;
                       });
        });
}

- (void)setTopPlaceData:(NSArray *)data
{
    if(_topPlaceData != data)
    {
        _topPlaceData = data;
        if(self.tableView.window) [self.tableView reloadData];
    }
}

- (NSArray *)topPlaceData
{
    return _topPlaceData;
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.topPlaceData count]];
    for(NSDictionary *dict in self.topPlaceData)
    {
        [annotations addObject:[FlickrTopPlaceAnnotation annotationForTopPlace:dict]];
 
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"View Photos From Place"])
    {
     PhotosInPlaceTableViewController *dest = segue.destinationViewController;
        
        //selectedPlace is set when a cell is selected
        NSDictionary *place = [self.topPlaceData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        dest.place = place;
        dest.navigationItem.title = [[[place objectForKey:@"_content"] componentsSeparatedByString:@", "] objectAtIndex:0];
        
    }
    else if([[segue identifier] isEqualToString:@"View Map"])
    {
        TopPlacesMapViewController *dest = segue.destinationViewController;
        dest.navigationItem.title = @"Top Places";
        dest.annotations = [self mapAnnotations];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topPlaceData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Place Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        NSString *place = [[self.topPlaceData objectAtIndex:indexPath.row] objectForKey:@"_content"];
        
        NSArray *placeParts = [place componentsSeparatedByString:@", "];
        
        cell.textLabel.text = [placeParts objectAtIndex:0];
        
        cell.detailTextLabel.text = [placeParts objectAtIndex:1];
        
        for(int i = 2; i < placeParts.count; i++) {
            cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingFormat:@", %@", [placeParts objectAtIndex:i]];
        }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
