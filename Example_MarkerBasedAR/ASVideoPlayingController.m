//
//  ASVideoPlayingController.m
//  AirStorm
//
//  Created by Acsa Lu on 6/13/13.
//
//

#import "ASVideoPlayingController.h"
#import "ASVideoSelectionViewController.h";

@interface ASVideoPlayingController ()

@end

@implementation ASVideoPlayingController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self embedYouTube];
}

- (void)embedYouTube {
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"http://www.youtube.com/v/%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    CGRect frame = _webView.frame;
    NSString* html = [NSString stringWithFormat:embedHTML, _videoId, frame.size.width, frame.size.height];

    
    [_webView loadHTMLString:html baseURL:nil];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reassign:(id)sender
{
    [self performSegueWithIdentifier:@"ReassignMedia" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ReassignMedia"]) {
        ASVideoSelectionViewController *vc = (ASVideoSelectionViewController *) segue.destinationViewController;
        vc.markerId = _markerId;
    }
}


@end
