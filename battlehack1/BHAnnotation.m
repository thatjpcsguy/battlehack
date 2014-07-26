//
//  BHAnnotation.m
//  battlehack1
//
//  Created by Asfanur Arafin on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import "BHAnnotation.h"

@implementation BHAnnotation

+ (BHAnnotation *)annotationForPhoto:(NSDictionary *)photo
{
    BHAnnotation *annotation = [[BHAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}

#pragma mark - MKAnnotation

- (NSString *)title
{
    return [self.photo objectForKey:@"title"];
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat: @"$%@",[self.photo objectForKey: @"price"]] ;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:@"lat"] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:@"lon"] doubleValue];
    return coordinate;
}


@end
