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
    [super viewDidLoad];//39 217 178
    
    /*
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar_background@2x.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
   
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor colorWithRed:39/255.0 green:217/255.0 blue:178/255.0 alpha:1.0];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"map_active.png"]];
     
     */
    UIColor *titleHighlightedColor = [UIColor colorWithRed:39/255.0 green:217/255.0 blue:178/255.0 alpha:1.0];
    
    [[UITabBar appearance] setTintColor: titleHighlightedColor];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background@2x.png"]]];

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

- (UIImage *)maskImage:(UIImage *)originalImage toPath:(UIBezierPath *)path {
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0);
    [path addClip];
    [originalImage drawAtPoint:CGPointZero];
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return maskedImage;
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
       UIImage *image =  [UIImage imageNamed:@"pin.png"];
        aView.image = image;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    BHAnnotation *bhAnnotation = annotation;
/*
   [NetworkManager imageFetcher:[bhAnnotation.photo objectForKey:@"thumbnail_url"] withCompletionhandler:^(BOOL sucess, UIImage *image){
        if (sucess) {
           
            UIImage *backgroundImage = [UIImage imageNamed:@"pin_ho.png"];
           
            UIBezierPath *circularPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(image.size.width/2, image.size.height/2)
                                          
                                                                        radius:12.5
                                          
                                                                    startAngle:0
                                          
                                                                      endAngle:360
                                          
                                                                     clockwise:YES];
            UIImage *circledImage = [self maskImage:image toPath:circularPath];
            
            
            UIGraphicsBeginImageContext(backgroundImage.size);
            [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
            //[circledImage drawInRect:CGRectMake(backgroundImage.size.width - circledImage.size.width, backgroundImage.size.height - circledImage.size.height, circledImage.size.width, circledImage.size.height)];
            [circledImage drawInRect:CGRectMake(0, 0, circledImage.size.width, circledImage.size.height)];
            
            
            UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            
            
            aView.image = result;
            
        }
    }];

    */
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    
    
    
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
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
