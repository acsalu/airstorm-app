//
//  ASDisplayMediaViewController.m
//  AirStorm
//
//  Created by Acsa Lu on 6/24/13.
//
//

#import "ASDisplayMediaViewController.h"
#import "ASData.h"
#import "LBYouTube.h"
#import "AFNetworking.h"

@interface ASDisplayMediaViewController ()

@end

@implementation ASDisplayMediaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem.title = @"Detection";
    NSString *mediaType = [ASData sharedData].mediaType;
    
    if ([mediaType isEqualToString:ASMediaTypeVideo]) {
        
        _player = [[LBYouTubePlayerViewController alloc] initWithYouTubeID:[ASData sharedData].videoId quality:LBYouTubeVideoQualityMedium];
        _player.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        _player.delegate = self;
        _player.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 586.0f);
        _player.view.center = CGPointMake(self.view.center.x, self.view.center.y - 6);
        [self.view addSubview:_player.view];
        
    } else {
        _imageView = [[UIImageView alloc] init];
        [_imageView setImageWithURL:[NSURL URLWithString:[ASData sharedData].imageURL]];
        _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
        _imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
        [self.view addSubview:_imageView];
    }
}

#pragma mark - LBYouTubePlayerControllerDelegate methods

- (void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    
}

- (void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error
{
    
}
    
@end
