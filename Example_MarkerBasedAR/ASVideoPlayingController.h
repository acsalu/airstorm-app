//
//  ASVideoPlayingController.h
//  AirStorm
//
//  Created by Acsa Lu on 6/13/13.
//
//

#import <UIKit/UIKit.h>

@interface ASVideoPlayingController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *videoId;
@property (nonatomic) int markerId;

- (IBAction)back:(id)sender;
- (IBAction)reassign:(id)sender;
@end
