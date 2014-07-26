//
//  BHAnnotation.h
//  battlehack1
//
//  Created by Asfanur Arafin on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface BHAnnotation : NSObject   <MKAnnotation>

+ (BHAnnotation *)annotationForPhoto:(NSDictionary *)photo;

@property (nonatomic, strong) NSDictionary *photo;


@end
