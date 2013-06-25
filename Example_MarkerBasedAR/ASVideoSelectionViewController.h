//
//  ASVideoSelectionViewController.h
//  AirStorm-test
//
//  Created by Acsa Lu on 6/13/13.
//
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface ASVideoSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    MBProgressHUD *HUD;
}

@property (nonatomic) int markerId;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic) BOOL isEditing;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSMutableArray *videos;
@property (strong, nonatomic) UITapGestureRecognizer *tap;


@end
