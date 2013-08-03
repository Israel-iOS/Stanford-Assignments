//
//  TestTableViewController.h
//  Assignment6
//
//  Created by Apple on 19/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhotoCache.h"

@class FlickrPhotoCache;

@interface TestTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *model;
@property (nonatomic, strong) NSArray *tableContent;

- (NSDictionary *)getInfoForRow:(NSInteger)row;

@end
