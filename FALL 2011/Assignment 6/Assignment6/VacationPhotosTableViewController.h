//
//  VacationPhotosTableViewController.h
//  Assignment6
//
//  Created by Apple on 05/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Place.h"

@interface VacationPhotosTableViewController : CoreDataTableViewController

@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic,strong) NSString *vacationName;

@end