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
    
    
    if ([[ASData sharedData].mediaType isEqualToString:ASMediaTypeImage]) {
        
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:[ASData sharedData].searchKeyword style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = newBackButton;
        
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
    } else {
        NSLog(@"%@", _image);
        _imageView.image = _image;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    HUD.labelText = @"Uploading Photo";
    
//    [HUD showWhileExecuting:@selector(choosePhoto) onTarget:self withObject:nil animated:YES];
}
                                 
- (void)choosePhoto
{
   
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD show:YES];
    
    if ([[ASData sharedData].mediaType isEqualToString:ASMediaTypePhoto]) {
        
        NSData *photoData = UIImageJPEGRepresentation(_image, 0.7);
        PFFile *photoFile = [PFFile fileWithName:@"photo.jpg" data:photoData];
        
        [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                PFObject *userPhoto = [PFObject objectWithClassName:@"PlayBack"];
                PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:[ASData sharedData].location];
                
                [userPhoto setObject:@([ASData sharedData].markerId) forKey:@"markerId"];
                [userPhoto setObject:[ASData sharedData].mediaType forKey:@"type"];
                [userPhoto setObject:photoFile forKey:@"photoFile"];
                [userPhoto setObject:photoFile.url forKey:@"imageURL"];
                [userPhoto setObject:geoPoint forKey:@"location"];
                
                HUD.mode = MBProgressHUDModeIndeterminate;
                HUD.labelText = @"Processing";
                
                [userPhoto saveEventually:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"save succeeded");
                        HUD.mode = MBProgressHUDModeCustomView;
                        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
                        sleep(2);
                        [self dismissViewControllerAnimated:YES completion:^{
                            [[ASData sharedData].displayMediaVC.navigationController popViewControllerAnimated:YES];
                        }];
                    } else {
                        NSLog(@"save failed");
                    }
                }];
            } else {
                NSLog(@"save failed");
            }
        } progressBlock:^(int percentDone) {
            HUD.progress = percentDone / 100.0f;
        }];
    } else {
        
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Processing";
        
        PFObject *webImage = [PFObject objectWithClassName:@"PlayBack"];
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:[ASData sharedData].location];
        
        [webImage setObject:@([ASData sharedData].markerId) forKey:@"markerId"];
        [webImage setObject:[ASData sharedData].mediaType forKey:@"type"];
        [webImage setObject:[ASData sharedData].imageURL forKey:@"imageURL"];
        [webImage setObject:geoPoint forKey:@"location"];
        
        
        [webImage saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"save succeeded");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
                sleep(2);
                [self dismissViewControllerAnimated:YES completion:^{
                    [[ASData sharedData].displayMediaVC.navigationController popViewControllerAnimated:YES];
                }];
                
            } else {
                NSLog(@"save failed");
            }
        }];
    }
    
    
}


@end
