//
//  BHFirstViewController.m
//  battlehack1
//
//  Created by Jimmy Young on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import "BHFirstViewController.h"
#import "NetworkManager.h"


@interface BHFirstViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLGeocoder *geocoder;
@property (strong,nonatomic) CLPlacemark *placemark;
@property (strong,nonatomic) NSString *trailingAddress;
@property (strong,nonatomic) NSString *leadingAddress;



@end

@implementation BHFirstViewController
#define METERS_PER_MILE 709.344

-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        
    }
    return _locationManager;
}

-(CLGeocoder *) geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return  _geocoder;
}




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
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
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
     CLLocation *location = [locations lastObject];
    [NetworkManager getItems:location.coordinate withURL:(int)METERS_PER_MILE withCompletionBlock:^(BOOL sucess, NSArray *array) {
        if (sucess) {
            NSLog(@"value %@",array);
        }
    }];

    [self.locationManager stopUpdatingLocation];
    [self getAddress:location];
    
    
    
    
}

-(void)getAddress:(CLLocation *)location{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            [self plotUserLocation];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
    
}

-(NSString *)getFirstAddress:(CLPlacemark *)placemark {
    return [NSString stringWithFormat:@"%@ %@",placemark.subThoroughfare,placemark.thoroughfare];
}


-(void) plotUserLocation {
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    self.trailingAddress = [NSString stringWithFormat:@"%@ %@ %@ %@",
                            
                            self.placemark.locality,
                            self.placemark.administrativeArea,self.placemark.postalCode,
                            self.placemark.country];
    
    
     self.leadingAddress = [self getFirstAddress:self.placemark];
    
    
    
    
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(self.placemark.location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [self.mapView setRegion:mapRegion];
    
    MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate:self.placemark.location.coordinate title:self.leadingAddress];
    [self.mapView addAnnotation:annotation];
    
    [self.mapView selectAnnotation:annotation animated:YES];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
