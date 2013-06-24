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
#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>


#define CELL_IMG_TAG 100
#define CELL_TITLE_TAG 101

NSString *YT_API_URL = @"https://www.googleapis.com/youtube/v3/search?q=%@&key=%@&part=snippet";
NSString *API_KEY = @"AIzaSyBDRlKTk3MQwjCzuY8O3o4VgexjwtXhY9Q";

@interface ASVideoSelectionViewController ()

@end

@implementation ASVideoSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter methods

- (NSMutableArray *)videos
{
    if (!_videos) _videos = [NSMutableArray arrayWithCapacity:5];
    return _videos;
}


# pragma mark - YouTube related methods

- (void)embedYoutube:(NSString *)videoId frame:(CGRect)frame
{
    NSString* embedHTML = [NSString stringWithFormat:
                           @"<html><head>"
                           "<style type='text/css'>"
                           "body {"
                           "background-color: transparent;"
                           "color: white;"
                           "}"
                           "</style>"
                           "</head><body style='margin:0'>"
                           "<embed id='yt' src='http://www.youtube.com/embed/%@?autoplay=1' type='application/x-shockwave-flash'"
                           "width='%0.0f' height='%0.0f'></embed>"
                           "</body></html>", @"M7lc1UVf-VE", frame.size.width, frame.size.height];
    
}


# pragma mark - UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar endEditing:YES];
    
    NSString *query = searchBar.text;
    NSLog(@"[Video Search] Search video for keyword: %@", query);
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
                                                            
                                                            NSString *title = videoInfo[@"snippet"][@"title"];
                                                            NSString *videoId = videoInfo[@"id"][@"videoId"];
                                                            NSString *thumbnailUrl = videoInfo[@"snippet"][@"thumbnails"][@"medium"][@"url"];
                                                            
                                                            NSLog(@"videoId: %@", videoInfo[@"id"][@"videoId"]);
                                                            NSLog(@"thumbnailUrl: %@", videoInfo[@"snippet"][@"thumbnails"][@"medium"][@"url"]);
                                                            
                                                            if (!title || !videoId || !thumbnailUrl) {
                                                                NSLog(@"videoInfo: %@", videoInfo);
                                                                break;
                                                            }
                                                            
                                                            [_videos addObject:@{@"title":title, @"videoId":videoId, @"thumbnailUrl":thumbnailUrl}];
                                                        }
                                                        
                                                        [_tableView reloadData];
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Select video: %@", _videos[indexPath.row][@"title"]);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", _videos[indexPath.row][@"videoId"]]];
    
    ASVideoTableViewCell *cell = (ASVideoTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[cell.imageView frame]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [cell addSubview:webView];
    
    PFObject *playBackObject = [PFObject objectWithClassName:@"PlayBack"];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:_latitude longitude:_longitude];
    [playBackObject setObject:@(_markerId) forKey:@"markerId"];
    [playBackObject setObject:_videos[indexPath.row][@"videoId"] forKey:@"videoId"];
    [playBackObject setObject:geoPoint forKey:@"location"];
    
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


@end
