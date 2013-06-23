//
//  ASPhotoDecideViewController.h
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import <UIKit/UIKit.h>

enum ASImageType {LOCAL, WEB};
typedef enum ASImageType ASImageType;

@interface ASPhotoDecideViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) ASImageType type;

- (void)choosePhoto;

@end
