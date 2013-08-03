//
//  FlickrAnnotation.h
//  Assignment6
//
//  Created by Apple on 11/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FlickrAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSDictionary *photo;
@property (nonatomic, strong) NSDictionary *place;

+ (FlickrAnnotation *)annotationForPhoto:(NSDictionary *)photo;
+ (FlickrAnnotation *)annotationForPlace:(NSDictionary *)place;

@end
