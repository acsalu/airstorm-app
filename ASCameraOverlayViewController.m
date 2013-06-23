//
//  ASCameraOverlayViewController.m
//  AirStorm
//
//  Created by Acsa Lu on 6/22/13.
//
//

#import "ASCameraOverlayViewController.h"

@interface ASCameraOverlayViewController ()

@end

@implementation ASCameraOverlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}


- (IBAction)takePhoto:(id)sender
{
    [self.picker takePicture];
}
@end
