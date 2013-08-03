//
//  FlickrPhotosInPlaceAnnotation.h
//  Assignment5
//
//  Created by Apple on 24/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPhotosInPlaceAnnotation : NSObject <MKAnnotation>

+ (FlickrPhotosInPlaceAnnotation *)annotationForPhoto:(NSDictionary *)photo;

@property (nonatomic, strong) NSDictionary *photo;

@end