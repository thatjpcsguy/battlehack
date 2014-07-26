//
//  BHListingViewController.h
//  battlehack1
//
//  Created by Jimmy Young on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface BHListingViewController : UIViewController<PayPalPaymentDelegate>
@property (strong, nonatomic) IBOutlet UILabel *priceUILabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UIImageView *listingImageView;

// Paypal
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
- (IBAction)buyButtonPressed:(id)sender;
@end
