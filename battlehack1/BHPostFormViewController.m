//
//  BHPostFormViewController.m
//  battlehack1
//
//  Created by Jimmy Young on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import "BHPostFormViewController.h"
#import "BHAppDelegate.h"
#import "NetworkManager.h"

@interface BHPostFormViewController ()

@end

@implementation BHPostFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageTap)];
    singleTap.numberOfTapsRequired = 1;
    self.listingImageView.userInteractionEnabled = YES;
    [self.listingImageView addGestureRecognizer:singleTap];
    
    //Creating a number tool bar accessory view
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.priceTextField.inputAccessoryView = numberToolbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    // Set up location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.longitude = [[NSNumber numberWithDouble:newLocation.coordinate.longitude] stringValue];
    self.latitude = [[NSNumber numberWithDouble:newLocation.coordinate.latitude] stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//Sell now button pressed here
- (IBAction)pressedPostButton:(id)sender {
    NSMutableDictionary *dataObject = [[NSMutableDictionary alloc] init];
    NSString *imageData = [UIImagePNGRepresentation(self.listingImageView.image) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [dataObject setObject:imageData forKey:@"image_data"];
    [dataObject setObject:self.titleTextField.text forKey:@"title_data"];
    [dataObject setObject:self.priceTextField.text forKey:@"price"];
    [dataObject setObject:self.descriptionTextField.text forKey:@"desc"];
    [dataObject setObject:self.longitude forKey:@"long"];
    [dataObject setObject:self.latitude forKey:@"lat"];
    BHAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [dataObject setObject:appDelegate.FBUser forKey:@"FBUser"];
    NSLog(@"%@", dataObject);
    [NetworkManager sendPostRequestTo:@"http://192.168.96.81:5000/listing" withData:dataObject withAsync:NO];
}

- (IBAction)pressedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addImageTap{
    NSLog(@"single Tap on imageview");
    [self galleryOrCameraChooser];
}

#pragma mark - Camera

- (void)galleryOrCameraChooser{
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select photo from:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera",
                            @"Photo Gallery",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    NSLog(@"CAMERA");
                    [self takePhoto];
                    break;
                case 1:
                    NSLog(@"PHOTO GALLERY");
                    [self selectPhoto];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


/* Take Photo */
- (IBAction)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

/* Selecting photo from picker */
- (IBAction)selectPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.listingImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.listingImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - TextFieldOptions

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

- (BOOL)doneWithNumberPad{
    [self.priceTextField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.scrollView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
}
//called when the text field is being edited
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    sender.delegate = self;
}
@end
