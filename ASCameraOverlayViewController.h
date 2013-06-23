//
//  ASCameraOverlayViewController.h
//  AirStorm
//
//  Created by Acsa Lu on 6/22/13.
//
//

#import <UIKit/UIKit.h>

@interface ASCameraOverlayViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) UIImagePickerController *picker;

- (IBAction)takePhoto:(id)sender;

@end
