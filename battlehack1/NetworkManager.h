//
//  NetworkManager.h
//  battlehack1
//
//  Created by Asfanur Arafin on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface NetworkManager : NSObject
typedef void (^JSONCompletionBlock) (BOOL sucess, NSDictionary *json);
typedef void (^ArrayCompletionBlock) (BOOL sucess, NSArray *array);
typedef void (^ImageCompletionBlock) (BOOL sucess, UIImage *image);

+(void)getItems:(CLLocationCoordinate2D)location withURL:(int)distance withCompletionBlock:(ArrayCompletionBlock)block;
+(void)imageFetcher:(NSString *)url withCompletionhandler:(ImageCompletionBlock)block;
+(BOOL)sendPostRequestTo:(NSString *)URL withData:(id)data withAsync:(BOOL)isAsync;
+(void)getMyStuffwithCompletionBlock:(ArrayCompletionBlock)block;

@end
