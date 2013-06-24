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

@interface ASDisplayMediaViewController : UIViewController <LBYouTubePlayerControllerDelegate>

@property (strong, nonatomic) LBYouTubePlayerViewController *player;
@property (strong, nonatomic) UIImageView *imageView;

@end
