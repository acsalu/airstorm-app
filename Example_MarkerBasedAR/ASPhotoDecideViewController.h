//
//  ASPhotoDecideViewController.h
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import <UIKit/UIKit.h>

@interface ASPhotoDecideViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

- (void)choosePhoto;

@end
