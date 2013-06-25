//
//  ASDisplayMediaViewController.h
//  AirStorm
//
//  Created by Acsa Lu on 6/24/13.
//
//

#import <UIKit/UIKit.h>

@class  LBYouTubePlayerViewController;
@protocol LBYouTubePlayerControllerDelegate;
@class MBProgressHUD;

@interface ASDisplayMediaViewController : UIViewController <LBYouTubePlayerControllerDelegate> {
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) LBYouTubePlayerViewController *player;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
