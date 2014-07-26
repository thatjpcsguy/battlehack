//
//  BHFirstViewController.m
//  battlehack1
//
//  Created by Jimmy Young on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import "BHFirstViewController.h"
#import "NetworkManager.h"
#import "BHAnnotation.h"


@interface BHFirstViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *location;
@end

@implementation BHFirstViewController
#define METERS_PER_MILE 709.344

-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        
    }
    return _locationManager;
}
- (void)setItems:(NSArray *)items
{
    if (_items != items) {
        _items = items;
        self.annotations = [self mapAnnotations];
    }
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}
- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [self.mapView setRegion:mapRegion];
    
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}


- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.items count]];
    for (NSDictionary *item in self.items) {
        [annotations addObject:[BHAnnotation annotationForPhoto:item]];
    }
    return annotations;
}


#pragma mark - MapViewControllerDelegate







- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self getCurrentLocation];
    
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}


- (void)getCurrentLocation {
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}



#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
       aView.image =  [UIImage imageNamed:@"pin@2x.jpg"];
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    BHAnnotation *bhAnnotation = (BHAnnotation *)aView.annotation;
    
    [NetworkManager imageFetcher:[bhAnnotation.photo objectForKey:@"image_url"] withCompletionhandler:^(BOOL sucess, UIImage *image){
        if (sucess) {
            [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
            
        }
    }];
    
    
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
}


#pragma mark - location manager delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
    [NetworkManager getItems:self.location.coordinate withURL:(int)METERS_PER_MILE withCompletionBlock:^(BOOL sucess, NSArray *array) {
        if (sucess) {
            NSLog(@"value %@",array);
            self.items = array;
        }
    }];
    
    if (self.location) {
        [self.locationManager stopUpdatingLocation];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
