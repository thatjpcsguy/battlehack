//
//  MyAnnotation.h
//  battlehack1
//
//  Created by Asfanur Arafin on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;


@end
