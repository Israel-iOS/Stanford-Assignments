//
//  VacationPlacesTableViewController.m
//  Assignment6
//
//  Created by Apple on 05/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VacationPlacesTableViewController.h"
#import "VacationHelper.h"
#import "Place.h"

@interface VacationPlacesTableViewController ()

@property (nonatomic, strong) UIManagedDocument *vacation;

@end

@implementation VacationPlacesTableViewController

@synthesize vacation = _vacation;
@synthesize vacationName = _vacationName;


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    // no predicate because we want ALL the Photographers
    
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
    static NSString *CellIdentifier = @"VacationPlaceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [place.photos count]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setPlaceName:)])
    {
        [segue.destinationViewController setTitle:place.name];
        [segue.destinationViewController performSelector:@selector(setPlaceName:) withObject:place.name];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setVacationName:)])
    {
        [segue.destinationViewController performSelector:@selector(setVacationName:) withObject:self.vacationName];
    }
}

@end
