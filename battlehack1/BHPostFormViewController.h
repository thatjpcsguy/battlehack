//
//  BHPostFormViewController.h
//  battlehack1
//
//  Created by Jimmy Young on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHPostFormViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *listingImageView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
- (IBAction)pressedPostButton:(id)sender;



@end
