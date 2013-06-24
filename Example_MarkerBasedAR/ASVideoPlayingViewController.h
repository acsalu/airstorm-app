//
//  ASVideoPlayingViewController.h
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import <UIKit/UIKit.h>

@class VideoPlayerKit;
@protocol VideoPlayerDelegate;

@interface ASVideoPlayingViewController : UIViewController <VideoPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (strong, nonatomic) VideoPlayerKit *videoPlayer;

- (IBAction)chooseVideo:(id)sender;
- (IBAction)playVideo:(id)sender;

@end
