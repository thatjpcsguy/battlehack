//
//  NetworkManager.m
//  battlehack1
//
//  Created by Asfanur Arafin on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import "NetworkManager.h"
#import <CoreLocation/CoreLocation.h>
#import "BHAppDelegate.h"

@implementation NetworkManager


+(void)getItems:(CLLocationCoordinate2D)location withURL:(int)distance withCompletionBlock:(ArrayCompletionBlock)block
{
    
    NSString *authinticateUrl = [NSString stringWithFormat:@"http://sellular.co/nearby/%f/%f/%d",location.latitude,location.longitude,distance];
    
    [self jsonFetcher:authinticateUrl withCompletionBlock:^(BOOL sucess, NSDictionary *array) {
        if (sucess) {
            block(YES,[[array allValues] lastObject]);
        }else{
            block(NO,nil);
        }
    }];
    
}

+(void)getMyStuffwithCompletionBlock:(ArrayCompletionBlock)block{
    BHAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *userid = [appDelegate.FBUser objectForKey:@"id"];
    NSString *url = [@"http://sellular.co/fetch/" stringByAppendingString:userid];
    
    [self jsonFetcher:url withCompletionBlock:^(BOOL sucess, NSDictionary *array) {
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

+(void)imageFetcher:(NSString *)query withCompletionhandler:(ImageCompletionBlock)block {
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
  
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            block(YES,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO,nil);
    }];
    [requestOperation start];

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
                                                                                                                            
     
     
+(BOOL)sendPostRequestTo:(NSString *)URL withData:(id)data withAsync:(BOOL)isAsync{
    //Set up the post data
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *post = [@"data=" stringByAppendingString:jsonString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    //set up the url
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    
    if ( isAsync ){
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if ([data length] > 0 && error == nil) {
                 NSLog(@"%@", response);
             }
         }];
    } else {
        NSError *error = nil;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        int responseStatusCode = [httpResponse statusCode];
        if (responseStatusCode == 200) {
            return TRUE;
        } else {
            NSLog(@"Not Status 200: %@", error);
            return false;
        }
    }
    
    NSLog(@"%@", response);
    return TRUE;
};

    


@end
