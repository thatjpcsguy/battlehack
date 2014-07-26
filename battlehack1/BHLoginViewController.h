//
//  BHLoginViewController.h
//  battlehack1
//
//  Created by Jimmy Young on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface BHLoginViewController : UIViewController <FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet FBLoginView *fbButtonLoginView;

@end
