//
//  VacationPhotosTableViewController.m
//  Assignment6
//
//  Created by Apple on 05/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VacationPhotosTableViewController.h"
#import "VacationHelper.h"
#import "FlickrHelper.h"
#import "Photo.h"

@interface VacationPhotosTableViewController ()

@property (nonatomic, strong) UIManagedDocument *vacation;

@end

@implementation VacationPhotosTableViewController

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES]];
    if (self.placeName)
    {
        request.predicate = [NSPredicate predicateWithFormat:@"place.name = %@", self.placeName];
    }
    else if (self.tagName)
    {
        request.predicate = [NSPredicate predicateWithFormat:@"any tags.name = %@", self.tagName];
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.vacation.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)setVacation:(UIManagedDocument *)vacation
{
    if (vacation != _vacation)
    {
        _vacation = vacation;
        [self setupFetchedResultsController];
    }
}

- (void)setVacationName:(NSString *)vacationName
{
    if(vacationName != _vacationName)
    {
        _vacationName = vacationName;
        [VacationHelper openVacation:_vacationName usingBlock:^(UIManagedDocument *vacation){
            self.vacation = vacation;
        }];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VacationPhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDictionary *info = [FlickrHelper getInfoForPhoto:[NSKeyedUnarchiver unarchiveObjectWithData:photo.data]];
    
    cell.textLabel.text = [info valueForKey:@"title"];
    cell.detailTextLabel.text = [info valueForKey:@"subtitle"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setPhoto:)])
    {
        NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithData:photo.data];
        [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:data];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setVacationName:)])
    {
        [segue.destinationViewController performSelector:@selector(setVacationName:) withObject:self.vacationName];
    }
}

@end
