//
//  ASPhotoDecideViewController.m
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import "ASPhotoDecideViewController.h"
#import "ASData.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import <Parse/Parse.h>

@interface ASPhotoDecideViewController ()

@end

@implementation ASPhotoDecideViewController

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
    
    UIBarButtonItem *chooseButton = [[UIBarButtonItem alloc] initWithTitle:@"Choose" style:UIBarButtonItemStylePlain target:self action:@selector(choosePhoto)];
    
    self.navigationItem.rightBarButtonItem = chooseButton;
    
    if (_type == WEB) {
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
        {
            NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[ASData sharedData].imageURL]];
            UIImage * image = [[UIImage alloc] initWithData:data];
            dispatch_async( dispatch_get_main_queue(), ^(void){
               if( image != nil )
               {
                   CGRect bounds;
                   
                   bounds.origin = CGPointZero;
                   bounds.size = image.size;
                   
                   _imageView.bounds = bounds;
                   _imageView.image = image;
                   
               } else {
                   
               }
            });
        });
//        [_imageView setImageWithURL:[NSURL URLWithString:[ASData sharedData].imageURL]];
    } else {
        NSLog(@"%@", _image);
        _imageView.image = _image;
    }
}
                                 
- (void)choosePhoto
{
    NSLog(@"Choose Photo");
    NSData *imageData = UIImageJPEGRepresentation(_image, 1.0);
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *userPhoto = [PFObject objectWithClassName:@"PlayBack"];
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:[ASData sharedData].location];
            [userPhoto setObject:@"type" forKey:@"photo"];
            [userPhoto setObject:@([ASData sharedData].markerId) forKey:@"markerId"];
            [userPhoto setObject:imageFile forKey:@"photoFile"];
            [userPhoto setObject:geoPoint forKey:@"location"];
            
            
            [userPhoto saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"save succeeded");
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    NSLog(@"save failed");
                }
            }];
        } else {
            NSLog(@"save failed");
        }
    }];
    
    
}


@end
