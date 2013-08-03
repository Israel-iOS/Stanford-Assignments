//
//  MapViewController.m
//  Assignment6
//
//  Created by Apple on 11/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MapViewController.h"
#import "FlickrAnnotation.h"
#import "FlickrFetcher.h"
#import "PhotosInPlaceTableViewController.h"
#import "PhotoScrollViewController.h"
#import "PhotosTableViewController.h"
#import "VacationHelper.h"

@interface MapViewController() <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

#pragma mark - Synchronize Model and View

- (MKCoordinateRegion)regionToFitAnnotations:(NSArray *) annotations
{
    CLLocationDegrees east=-180,west=180,north=-90,south=90;
    for(id <MKAnnotation> annotation in annotations)
    {
        CLLocationCoordinate2D coordinate = [annotation coordinate];
        if(coordinate.longitude > east) east = coordinate.longitude;
        if(coordinate.longitude < west) west = coordinate.longitude;
        if(coordinate.latitude > north) north = coordinate.latitude;
        if(coordinate.latitude < south) south = coordinate.latitude;
    }
    return MKCoordinateRegionMake(CLLocationCoordinate2DMake((north+south)/2, (east+west)/2), MKCoordinateSpanMake(north-south, east-west));
}

- (void)updateMapView
{
    MKCoordinateRegion region;
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
    region = [self regionToFitAnnotations:self.annotations];
    [self.mapView setRegion: region];
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

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    FlickrAnnotation *fa = annotation;
    
    //NSLog(@"title=%@", [fa.photo objectForKey:@"title"]);
    
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        //aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    aView.rightCalloutAccessoryView = rightButton;
    aView.annotation = fa;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
        
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
            id <MKAnnotation> annotation = aView.annotation;
        UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
        if(image && aView.annotation == annotation)
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
            });
        }
    });
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if([view.annotation isKindOfClass:[FlickrAnnotation class]])
    {
        FlickrAnnotation *fpa = (FlickrAnnotation *)view.annotation;
      
 [self performSegueWithIdentifier:@"ShowImage" sender:fpa];
    }
    [self.delegate didTappedAccessoryControlOfAnnotation: view.annotation];
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setMapView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - Autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if([segue.identifier isEqualToString:@"ShowImage"])
    {
        NSDictionary *photo = sender;
        PhotoScrollViewController *photoScrollViewController = [segue destinationViewController];
        photoScrollViewController.vacationName = DEFAULT_VACATION_NAME;
        
        [self prepareImageForPhotoScrollViewController:photoScrollViewController withPhoto:photo];
    }
    
    //NSLog(@"%@\n",photo);
}


- (void)prepareImageForPhotoScrollViewController:(PhotoScrollViewController *)photoScrollViewController withPhoto:(NSDictionary *)photo
{
    photoScrollViewController.photo = photo;
}

@end
