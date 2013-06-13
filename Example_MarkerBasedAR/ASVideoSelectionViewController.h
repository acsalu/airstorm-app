//
//  ASVideoSelectionViewController.h
//  AirStorm-test
//
//  Created by Acsa Lu on 6/13/13.
//
//

#import <UIKit/UIKit.h>

@interface ASVideoSelectionViewController : UIViewController

@property (nonatomic) int markerId;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *videos;

- (IBAction)cancelSelection:(id)sender;

@end
