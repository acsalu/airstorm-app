//
//  ASVideoPlayingViewController.h
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@class  LBYouTubePlayerViewController;
@protocol LBYouTubePlayerControllerDelegate;
@protocol MBProgressHUDDelegate;
@class MBProgressHUD;

@interface ASVideoPlayingViewController : UIViewController <LBYouTubePlayerControllerDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) LBYouTubePlayerViewController *player;

- (IBAction)chooseVideo:(id)sender;
- (IBAction)playVideo:(id)sender;

@end
