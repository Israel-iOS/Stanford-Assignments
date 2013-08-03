//
//  PhotoScrollViewController.h
//  Assignment6
//
//  Created by Apple on 06/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollViewController : UIViewController

@property (nonatomic,strong) NSDictionary *photo;
@property (nonatomic,strong) NSString *vacationName;

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;

@end
