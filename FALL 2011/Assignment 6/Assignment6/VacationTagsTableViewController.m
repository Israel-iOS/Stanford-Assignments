//
//  VacationTagsTableViewController.m
//  Assignment6
//
//  Created by Apple on 05/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VacationTagsTableViewController.h"
#import "VacationHelper.h"
#import "Tag+Create.h"


@interface VacationTagsTableViewController()

@property (nonatomic, strong) UIManagedDocument *vacation;

@end

@implementation VacationTagsTableViewController

@synthesize vacationName = _vacationName;

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]];
    // no predicate because we want ALL the Photographers
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.vacation.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

-(void)setVacation:(UIManagedDocument *)vacation
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
    static NSString *CellIdentifier = @"VacationTagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = tag.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [tag.photos count]];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"jejeje"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setTagName:)])
    {
        [segue.destinationViewController setTitle:tag.name];
        [segue.destinationViewController performSelector:@selector(setTagName:) withObject:tag.name];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setVacationName:)])
    {
        [segue.destinationViewController performSelector:@selector(setVacationName:) withObject:self.vacationName];
    }
}

@end
