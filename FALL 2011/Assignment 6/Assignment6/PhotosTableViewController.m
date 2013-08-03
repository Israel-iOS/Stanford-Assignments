//
//  PhotosTableViewController.m
//  Assignment6
//
//  Created by Apple on 11/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "MapViewController.h"
#import "FlickrPhotoCache.h"
#import "FlickrAnnotation.h"


@interface PhotosTableViewController() <MapViewControllerDelegate>

@property (readonly, nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation PhotosTableViewController

@synthesize spinner = _spinner;

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation
{
    return nil;
}

- (void)didTappedAccessoryControlOfAnnotation:(id <MKAnnotation>)annotation
{
    
}

- (UIActivityIndicatorView *)spinner
{
    if(!_spinner)
    {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [_spinner setColor:[UIColor grayColor]];
    }    
    return _spinner;
}

- (void)showSpinner:(BOOL)isShow
{
    if (isShow)
    {
        self.tableView.scrollEnabled = NO;
        //NSLog(@"%@", self.tableView.separatorColor);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.spinner startAnimating];
    }
    else
    {
        self.tableView.scrollEnabled = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.spinner stopAnimating];
    }
}

- (void)setDataArray:(NSArray *)dataArray
{
    if(_dataArray != dataArray)
    {
        _dataArray = dataArray;
        [self showSpinner:NO];
        [self.tableView reloadData];
    }
}

- (NSDictionary *)getInfoForRow:(NSInteger)row
{
    return nil;
}

- (NSArray *)mapAnnotations
{
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowMap"])
    {
        MapViewController *mvc = [segue destinationViewController];
        mvc.delegate = self;
        mvc.annotations = [self mapAnnotations];
        return;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.view addSubview:self.spinner];
    [self showSpinner:(self.dataArray==NULL)];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.spinner.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   
    if (cell == nil)
    {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
   
    NSDictionary *info = [self getInfoForRow:indexPath.row];
    cell.textLabel.text = [info valueForKey:@"title"];
    cell.detailTextLabel.text = [info valueForKey:@"subtitle"];

return cell;
                       
}

@end
