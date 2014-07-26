//
//  BHPostFormViewController.m
//  battlehack1
//
//  Created by Jimmy Young on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import "BHPostFormViewController.h"

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

    // Do any additional setup after loading the view.
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

- (IBAction)pressedPostButton:(id)sender {
}

-(void)addImageTap{
    NSLog(@"single Tap on imageview");
    [self galleryOrCameraChooser];
}


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
    self.listingImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
