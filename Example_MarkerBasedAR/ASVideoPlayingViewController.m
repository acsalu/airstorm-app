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
#import "MBProgressHUD.h"
#import "LBYouTube.h"
#import <Parse/Parse.h>

@interface ASVideoPlayingViewController ()

@end

@implementation ASVideoPlayingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _player = [[LBYouTubePlayerViewController alloc] initWithYouTubeID:[ASData sharedData].videoId quality:LBYouTubeVideoQualityMedium];
    _player.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    _player.delegate = self;
    _player.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 586.0f);
    _player.view.center = CGPointMake(self.view.center.x, self.view.center.y - 4);
    [self.view addSubview:_player.view];
    
}


- (IBAction)chooseVideo:(id)sender
{
    PFObject *playBackObject = [PFObject objectWithClassName:@"PlayBack"];
    [playBackObject setObject:@([ASData sharedData].markerId) forKey:@"markerId"];
    [playBackObject setObject:[ASData sharedData].videoId forKey:@"videoId"];
    [playBackObject setObject:[PFGeoPoint geoPointWithLocation:[ASData sharedData].location] forKey:@"location"];
    [playBackObject setObject:ASMediaTypeVideo forKey:@"type"];
    
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

#pragma mark - LBYouTubePlayerControllerDelegate methods

- (void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    
}

- (void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error
{
    
}

@end
