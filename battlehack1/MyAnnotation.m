//
//  MyAnnotation.m
//  battlehack1
//
//  Created by Asfanur Arafin on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
    }
    return self;
}


@end
