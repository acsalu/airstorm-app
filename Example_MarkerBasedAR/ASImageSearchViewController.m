//
//  ASImageSearchViewController.m
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import "ASImageSearchViewController.h"
#import "ASPhotoCollectionViewCell.h"
#import "ASPhotoDecideViewController.h"
#import "ASData.h"
#import "AFNetworking.h"

NSString *const FlickrAPIKey = @"43837ea27d9b418da418f0616b74bdd7";

@interface ASImageSearchViewController ()

@end

@implementation ASImageSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:_tap];
    [_tap setEnabled:NO];
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

// with lazy instatiation
- (NSMutableArray *)imageInfos
{
    if (!_imageInfos) _imageInfos = [NSMutableArray array];
    return _imageInfos;
}

#pragma mark - Flickr API request methods

- (void)searchImageForKeyword:(NSString *)keyword
{
    if ([_currentKeyword isEqualToString:keyword]) {
        NSLog(@"[Image Search] Keep searching for keyword: %@", _currentKeyword);
        ++_page;
    } else {
        NSLog(@"[Image Search] Searching image for keyword: %@", keyword);
        [ASData sharedData].searchKeyword = keyword;
        _currentKeyword = keyword;
        _page = 1;
        _imageInfos = [NSMutableArray array];
    }
    
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&page=%d&per_page=25&format=json&nojsoncallback=1",
     FlickrAPIKey, keyword, _page];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"[Image Search] Request URL: %@", urlString);
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        NSLog(@"[Image Search] Search succeeded!");
                                                        NSArray *photos = JSON[@"photos"][@"photo"];
                                                        NSLog(@"[Image Search] %d results", photos.count);
                                                        
                                                        for (NSDictionary *photo in photos) {
                                                            NSString *title = photo[@"title"];
                                                            if (!title) title = @"Untitled";
                                                            
                                                            NSString *thumbnailURLString =
                                                            [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg",
                                                             photo[@"farm"], photo[@"server"], photo[@"id"], photo[@"secret"]];
                                                            
                                                            NSString *photoURLString =
                                                            [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_z.jpg",
                                                             photo[@"farm"], photo[@"server"], photo[@"id"], photo[@"secret"]];
                                                            
                                                            NSLog(@"%@", photoURLString);
                                                            
                                                            NSDictionary *info = @{@"title":title, @"thumbnailURL":thumbnailURLString, @"imageURL":photoURLString};
                                                            [self.imageInfos addObject:info];
                                                        }
                                                        
                                                        [self.collectionView reloadData];
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"[Image Search] Search failed...");
                                                    }];
    [operation start];

}

#pragma mark - UISearchBarDelegate methods

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
    [searchBar endEditing:YES];
    self.isEditing = NO;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [self searchImageForKeyword:searchBar.text];
    
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageInfos.count > 0) return self.imageInfos.count + 1;
    else return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ASPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    if (indexPath.row == self.imageInfos.count) {
        cell.imageView.image = [UIImage imageNamed:@"more-button-normal"];
    } else {
        [cell.imageView setImageWithURL:[NSURL URLWithString:self.imageInfos[indexPath.row][@"thumbnailURL"]]];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.imageInfos.count) {
        [self searchImageForKeyword:_currentKeyword];
    } else {
        [ASData sharedData].mediaType = ASMediaTypeImage;
        [ASData sharedData].imageURL = _imageInfos[indexPath.row][@"imageURL"];
        
        [self performSegueWithIdentifier:@"DecideImage" sender:self];

    }
}

@end
