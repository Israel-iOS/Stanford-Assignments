//
//  TopPlacesMapViewController.h
//  Assignment5
//
//  Created by Apple on 24/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TopPlacesMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *annotations;

@end
