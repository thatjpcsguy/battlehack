//
//  BHFirstViewController.h
//  battlehack1
//
//  Created by Jimmy Young on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"

@class BHFirstViewController;

@protocol MapViewControllerDelegate <NSObject>
- (UIImage *)mapViewController:(BHFirstViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end



@interface BHFirstViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) NSArray *annotations; // of id <MKAnnotation>
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;

@end
