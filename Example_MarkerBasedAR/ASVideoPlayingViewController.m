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
    _player.view.center = CGPointMake(self.view.center.x, self.view.center.y - 6);
    [self.view addSubview:_player.view];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Processing";
    
}

- (void)viewDidAppear:(BOOL)animated
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:[ASData sharedData].searchKeyword style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    
    [super viewDidAppear:animated];
}


- (IBAction)chooseVideo:(id)sender
{
    [HUD show:YES];
    PFObject *playBackObject = [PFObject objectWithClassName:@"PlayBack"];
    [playBackObject setObject:@([ASData sharedData].markerId) forKey:@"markerId"];
    [playBackObject setObject:[ASData sharedData].videoId forKey:@"videoId"];
    [playBackObject setObject:[PFGeoPoint geoPointWithLocation:[ASData sharedData].location] forKey:@"location"];
    [playBackObject setObject:ASMediaTypeVideo forKey:@"type"];
    
    
    [playBackObject saveEventually:^(BOOL succeeded, NSError *error) {
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
}

#pragma mark - LBYouTubePlayerControllerDelegate methods

- (void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    
}

- (void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error
{
    
}

@end
