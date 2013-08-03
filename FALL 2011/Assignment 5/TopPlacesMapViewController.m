//
//  TopPlacesMapViewController.m
//  Assignment5
//
//  Created by Apple on 24/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "TopPlacesMapViewController.h"
#import "FlickrTopPlaceAnnotation.h"
#import "FlickrFetcher.h"
#import "FlickrPhotosInPlaceAnnotation.h"
#import <MapKit/MapKit.h>
#import "PhotosInPlaceTableViewController.h"
#import "PhotoViewController.h"

@interface TopPlacesMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation TopPlacesMapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self zoomToFitMapAnnotations:self.mapView];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (void)updateMapView
{
    self.mapView.delegate = self;
    if(self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.annotations];
    if(self.mapView.window) [self zoomToFitMapAnnotations:self.mapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"View Photos From Place"])
    {
        FlickrTopPlaceAnnotation *fpa = sender; //(FlickrPlaceAnnotation *)
      PhotosInPlaceTableViewController *dest = segue.destinationViewController;
        dest.place = fpa.place;
        dest.navigationItem.title = [[[dest.place objectForKey:@"_content"] componentsSeparatedByString:@", "] objectAtIndex:0];
    }
    else if([segue.identifier isEqualToString:@"View Photo"])
    {
        PhotoViewController *dest = segue.destinationViewController;
        FlickrPhotosInPlaceAnnotation *fpa = sender;
        dest.photo = fpa.photo;
        if(![[fpa.photo objectForKey:@"title"] isEqual: @""])
        {
            dest.navigationItem.title =[fpa.photo objectForKey:@"title"];
        }
        else
        {
            dest.navigationItem.title = @"Unknown";
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *aView = [theMapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if(!aView)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        if([annotation isKindOfClass:[FlickrPhotosInPlaceAnnotation class]])
        {
            aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        }
    }
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    aView.rightCalloutAccessoryView = rightButton;
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if([view.annotation isKindOfClass:[FlickrPhotosInPlaceAnnotation class]])
    {
        FlickrPhotosInPlaceAnnotation *fpa = (FlickrPhotosInPlaceAnnotation *)view.annotation;
        
        NSDictionary *photo = fpa.photo;
        if(self.splitViewController)
        {
            id detail = [self.splitViewController.viewControllers lastObject];
            if([detail isKindOfClass:[PhotoViewController class]])
            {
                PhotoViewController *photoVC = detail;
                photoVC.photo = photo;
                if(![[photo objectForKey:@"title"] isEqual: @""])
                {
                    photoVC.navigationItem.title =[photo objectForKey:@"title"];
                }
                else
                {
                    photoVC.navigationItem.title = @"Unknown";
                }
            }
        }
        else
        {
            [self performSegueWithIdentifier:@"View Photo" sender:fpa];
        }
    }
    else if([view.annotation isKindOfClass:[FlickrTopPlaceAnnotation class]])
    {
        FlickrTopPlaceAnnotation *fpa = (FlickrTopPlaceAnnotation *)view.annotation;
        
        [self performSegueWithIdentifier:@"View Photos From Place" sender:fpa];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[FlickrPhotosInPlaceAnnotation class]])
    {
        FlickrPhotosInPlaceAnnotation *fpa = (FlickrPhotosInPlaceAnnotation *)view.annotation;
        
        dispatch_queue_t downlaodQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downlaodQueue, ^{
            NSURL *photoURL = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
            NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
            UIImage *photoImage = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [(UIImageView *)view.leftCalloutAccessoryView setImage:photoImage];
            });
        });
        
    }
}

- (void)zoomToFitMapAnnotations:(MKMapView*)mapView
{
    //return;
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    if(region.span.latitudeDelta > 360) region.span.latitudeDelta = 360;
    if(region.span.longitudeDelta > 180) region.span.longitudeDelta = 180;
    
    [mapView setRegion:region animated:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
