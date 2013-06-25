//
//  ASVideoSearchViewController.m
//  airstorm-app
//
//  Created by Acsa Lu on 6/6/13.
//  Copyright (c) 2013 com.nmlab.g7. All rights reserved.
//

#import "ASVideoSelectionViewController.h"
#import "AFNetworking.h"
#import "ASVideoTableViewCell.h"
#import "MBProgressHUD.h"
#import "ASVideoPlayingController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>
#import "ASData.h"
#import "HCYoutubeParser.h"


#define CELL_IMG_TAG 100
#define CELL_TITLE_TAG 101

NSString *YT_API_URL = @"https://www.googleapis.com/youtube/v3/search?q=%@&key=%@&part=snippet&maxResults=25";
NSString *API_KEY = @"AIzaSyBDRlKTk3MQwjCzuY8O3o4VgexjwtXhY9Q";

@interface ASVideoSelectionViewController ()

@end

@implementation ASVideoSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:_tap];
    [_tap setEnabled:NO];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Loading";
}

- (void)dismissKeyboard
{
    if (_isEditing) {
        [_searchBar endEditing:YES];
        [_searchBar setShowsCancelButton:NO animated:YES];
        self.isEditing = NO;
    }
}
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setter & Getter methods

- (void)setIsEditing:(BOOL)isEditing
{
    [_tap setEnabled:isEditing];
    _isEditing = isEditing;
}

- (NSMutableArray *)videos
{
    if (!_videos) _videos = [NSMutableArray arrayWithCapacity:5];
    return _videos;
}


# pragma mark - UISearchBarDelegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    self.isEditing = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    self.isEditing = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar endEditing:YES];
    self.isEditing = NO;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    
    NSString *query = searchBar.text;
    NSLog(@"[Video Search] Search video for keyword: %@", query);
    [ASData sharedData].searchKeyword = query;
    
    _videos = [NSMutableArray arrayWithCapacity:5];
    
    NSString *urlString = [NSString stringWithFormat:YT_API_URL, query, API_KEY];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSLog(@"[Video Search] Request url: %@", url);
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        NSLog(@"kind: %@", [JSON valueForKey:@"kind"]);
                                                        for (NSDictionary *videoInfo in [JSON valueForKey:@"items"]) {
                                                            if ([videoInfo[@"id"][@"kind"] isEqualToString:@"youtube#video"]) {
                                                            
                                                                NSString *title = videoInfo[@"snippet"][@"title"];
                                                                NSString *videoId = videoInfo[@"id"][@"videoId"];
                                                                NSString *thumbnailUrl = videoInfo[@"snippet"][@"thumbnails"][@"medium"][@"url"];
                                                                
                                                                NSLog(@"videoId: %@", videoInfo[@"id"][@"videoId"]);
                                                                NSLog(@"thumbnailUrl: %@", videoInfo[@"snippet"][@"thumbnails"][@"medium"][@"url"]);
                                                                
                                                                [_videos addObject:@{@"title":title, @"videoId":videoId, @"thumbnailUrl":thumbnailUrl}];
                                                            
                                                            }
                                                            
                                                            
                                                        }
                                                        
                                                        [_tableView reloadData];
                                                        [HUD hide:YES];
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                    }];
    

    [HUD show:YES];
    [operation start];
    
}

# pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ASVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)	
        cell = [[ASVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSURL *url = [NSURL URLWithString:_videos[indexPath.row][@"thumbnailUrl"]];
    [cell.thumbnail setImageWithURL:url];
    
    cell.title.text = _videos[indexPath.row][@"title"];
    
    
    return cell;
}

# pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    NSLog(@"reload!!");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Select video: %@", _videos[indexPath.row][@"title"]);
    [ASData sharedData].videoId = _videos[indexPath.row][@"videoId"];
    
    [self performSegueWithIdentifier:@"PlayVideo" sender:self];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0 && indexPath.row == self.videos.count - 1) {
        NSLog(@"[Video Search] Load more!");
    }
}

@end
