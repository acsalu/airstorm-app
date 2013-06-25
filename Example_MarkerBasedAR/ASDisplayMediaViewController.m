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
#import "MBProgressHUD.h"

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
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Loading";
    
    [ASData sharedData].displayMediaVC = self;
    
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
        
        NSLog(@"[Display Media] ImageURL: %@", [ASData sharedData].imageURL);
//        [HUD show:YES];
        NSURL *url = [NSURL URLWithString:[ASData sharedData].imageURL];
//        [_imageView setImageWithURL:url];
    
//        [_imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"media-display-placeholder"]];
        
        [HUD show:YES];
        [_imageView setImageWithURLRequest:[NSURLRequest requestWithURL:url]
                          placeholderImage:[UIImage imageNamed:@"media-display-placeholder"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       _imageView.image = image;
                                       [HUD hide:YES];
            
        } failure:nil];
        
//        __weak typeof(self) weakSelf = self;
//        __weak MBProgressHUD *weakHUD = HUD;
//        [_imageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//            [weakHUD hide:YES];
//            _imageView.image = image;
//            _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
//            _imageView.center = CGPointMake(weakSelf.view.center.x, weakSelf.view.center.y - 30);
////            [weakSelf.view addSubview:weakImageView];
//            
//            
//        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//            
//        }];
        
        
        NSLog(@"[Display Media] ImageURL: %@", [ASData sharedData].imageURL);

//        _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
//        _imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 30);

    }
}

#pragma mark - StoryBoard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[ASData sharedData].mediaType isEqualToString:ASMediaTypeVideo]) {
        [_player.moviePlayer stop];
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
