//
//  FlickrTopPlaceAnnotation.m
//  Assignment5
//
//  Created by Apple on 24/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "FlickrTopPlaceAnnotation.h"

@implementation FlickrTopPlaceAnnotation

+ (FlickrTopPlaceAnnotation *)annotationForTopPlace:(NSDictionary *)place
{
    FlickrTopPlaceAnnotation *annotation = [[FlickrTopPlaceAnnotation alloc]init];
    annotation.place = place;
    return annotation;
}

- (NSString *)title
{
    NSArray *placeParts = [[self.place objectForKey:@"_content"] componentsSeparatedByString:@", "];
    
    return [placeParts objectAtIndex:0];
}

- (NSString *)subtitle
{
    NSArray *placeParts = [[self.place objectForKey:@"_content"] componentsSeparatedByString:@", "];
    
    NSString *subtitle = [placeParts objectAtIndex:1];
    
    for(int i = 2; i < placeParts.count; i++)
    {
        subtitle = [subtitle stringByAppendingFormat:@", %@", [placeParts objectAtIndex:i]];
    }
    return subtitle;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:@"latitude"] doubleValue];
    coordinate.longitude = [[self.place objectForKey:@"longitude"] doubleValue];
    return coordinate;
}

@end
