//
//  FlickrPhotosInPlaceAnnotation.m
//  Assignment5
//
//  Created by Apple on 24/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "FlickrPhotosInPlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotosInPlaceAnnotation

+ (FlickrPhotosInPlaceAnnotation *)annotationForPhoto:(NSDictionary *)photo
{
    FlickrPhotosInPlaceAnnotation *annotation = [[FlickrPhotosInPlaceAnnotation alloc]init];
    annotation.photo = photo;
    return annotation;
}

- (NSString *)title
{
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}

- (NSString *)subtitle
{
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:@"latitude"] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:@"longitude"] doubleValue];
    return coordinate;
}

@end
