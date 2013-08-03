//
//  VacationSearchTableViewController.m
//  Assignment6
//
//  Created by Apple on 05/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VacationSearchTableViewController.h"
#import "VacationHelper.h"
#import "VacationPlacesTableViewController.h"
#import "VacationTagsTableViewController.h"

@interface VacationSearchTableViewController ()

@end

@implementation VacationSearchTableViewController

@synthesize vacationName = _vacationName;

- (void)setVacationName:(NSString *)vacationName
{
    if (vacationName != _vacationName)
    {
        _vacationName = vacationName;
        self.title = vacationName;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VacationPlaces"] || [segue.identifier isEqualToString:@"VacationTags"])
    {
        id viewController = segue.destinationViewController;
        
        if ([viewController respondsToSelector:@selector(setVacationName:)])
        {
            [viewController performSelector:@selector(setVacationName:) withObject:self.vacationName];
        }
    }
}

@end
