//
//  NetworkManager.m
//  battlehack1
//
//  Created by Asfanur Arafin on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

/*

+(void)jsonFetcher:(NSString *)query returnTypeIsDictionary:(BOOL)isDictionary supressAlert:(BOOL)supress withCompletionBlock: (JSONCompletionBlock)callback {
  
    
    
    
    // 1
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"query %@",query);
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:200];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 3
        if (responseObject) {
            isDictionary?callback(YES,(NSDictionary *)responseObject):callback(YES,@{@"result":(NSArray *)responseObject});
            
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
        
        if (!supress) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:url.host
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        callback(NO,nil);
    }];
    
    // 5
    [operation start];
    
}
                                                                                                                            
     
     
  

    
}
*/
@end
