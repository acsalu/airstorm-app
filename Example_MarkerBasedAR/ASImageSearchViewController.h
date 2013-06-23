//
//  ASImageSearchViewController.h
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import <UIKit/UIKit.h>

@interface ASImageSearchViewController : UIViewController <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *imageInfos;
@property (strong, nonatomic) NSString *currentKeyword;
@property (nonatomic) int page;

@end
