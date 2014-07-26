//
//  NetworkManager.m
//  battlehack1
//
//  Created by Asfanur Arafin on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import "NetworkManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation NetworkManager


+(void)getItems:(CLLocationCoordinate2D)location withURL:(int)distance withCompletionBlock:(ArrayCompletionBlock)block
{
    
    
    NSString *authinticateUrl = [NSString stringWithFormat:@"http://192.168.96.81:5000/nearby/%f/%f/%d",location.latitude,location.longitude,distance];
    
    [self jsonFetcher:authinticateUrl withCompletionBlock:^(BOOL sucess, NSDictionary *array) {
        if (sucess) {
            block(YES,[[array allValues] lastObject]);
        }else{
            block(NO,nil);
        }
    }];
    
    
}

+(UIImage *)getItemImagewithURL:(NSString *)url {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return data ? [UIImage imageWithData:data] : nil;
}



+(void)jsonFetcher:(NSString *)query   withCompletionBlock: (JSONCompletionBlock)callback {
  
    
    
    
    // 1
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:200];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 3
        if (responseObject) {
            callback(YES,responseObject);
            
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                message:@"Cannot Connect to Server"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            
            
            callback(NO,nil);
            
            
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:url.host
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
         callback(NO,nil);
    }];
    
    // 5
    [operation start];
    
}
                                                                                                                            
     
     
  

    


@end
