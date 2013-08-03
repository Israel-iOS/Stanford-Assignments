//
//  PhotosTableViewController.h"
//  Assignment6
//
//  Created by Apple on 11/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataArray;

- (NSDictionary *)getInfoForRow:(NSInteger)row;

@end
