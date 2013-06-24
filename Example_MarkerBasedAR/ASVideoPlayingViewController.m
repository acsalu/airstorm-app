//
//  ASVideoPlayingViewController.m
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import "ASVideoPlayingViewController.h"
#import "ASData.h"
#import "HCYoutubeParser.h"
#import "VideoPlayerKit.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface ASVideoPlayingViewController ()

@end

@implementation ASVideoPlayingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", [ASData sharedData].videoId]];
    NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:url];
    
    NSLog(@"%@", videos[@"medium"]);
    
    
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[videos objectForKey:@"medium"]]];
//    [self presentMoviePlayerViewControllerAnimated:mp];
    
    NSURL *testUrl = [NSURL URLWithString:@"http://ignhdvod-f.akamaihd.net/i/assets.ign.com/videos/zencoder/,416/d4ff0368b5e4a24aee0dab7703d4123a-110000,640/d4ff0368b5e4a24aee0dab7703d4123a-500000,640/d4ff0368b5e4a24aee0dab7703d4123a-1000000,960/d4ff0368b5e4a24aee0dab7703d4123a-2500000,1280/d4ff0368b5e4a24aee0dab7703d4123a-3000000,-1354660143-w.mp4.csmil/master.m3u8"];
    
    
    
    _videoPlayer = [VideoPlayerKit videoPlayerWithContainingViewController:self optionalTopView:self.controlView hideTopViewWithControls:YES];
    [_videoPlayer setControlsEdgeInsets:UIEdgeInsetsMake(self.controlView.frame.size.height, 0, 0, 0)];
    _videoPlayer.delegate = self;
    _videoPlayer.allowPortraitFullscreen = NO;
    

    [self.contentView addSubview:self.videoPlayer.videoPlayerView];
    [_videoPlayer playVideoWithTitle:@""
                                 URL:[NSURL URLWithString:videos[@"medium"]]
                             videoID:nil shareURL:nil isStreaming:NO playInFullScreen:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseVideo:(id)sender
{
    PFObject *playBackObject = [PFObject objectWithClassName:@"PlayBack"];
    [playBackObject setObject:@([ASData sharedData].markerId) forKey:@"markerId"];
    [playBackObject setObject:[ASData sharedData].videoId forKey:@"videoId"];
    [playBackObject setObject:[PFGeoPoint geoPointWithLocation:[ASData sharedData].location] forKey:@"location"];
    [playBackObject setObject:@"type" forKey:@"video"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [playBackObject saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"save succeeded");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"save failed");
        }
    }];
    
}

- (IBAction)playVideo:(id)sender {
}
@end
