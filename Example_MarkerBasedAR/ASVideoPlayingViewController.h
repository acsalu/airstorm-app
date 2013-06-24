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

@interface ASVideoPlayingViewController : UIViewController <LBYouTubePlayerControllerDelegate>

@property (strong, nonatomic) LBYouTubePlayerViewController *player;

- (IBAction)chooseVideo:(id)sender;
- (IBAction)playVideo:(id)sender;

@end
