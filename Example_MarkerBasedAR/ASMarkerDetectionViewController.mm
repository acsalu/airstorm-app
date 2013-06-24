/*****************************************************************************
 *   ViewController.mm
 *   Example_MarkerBasedAR
 ******************************************************************************
 *   by Khvedchenia Ievgen, 5th Dec 2012
 *   http://computer-vision-talks.com
 ******************************************************************************
 *   Ch2 of the book "Mastering OpenCV with Practical Computer Vision Projects"
 *   Copyright Packt Publishing 2012.
 *   http://www.packtpub.com/cool-projects-with-opencv/book
 *****************************************************************************/

////////////////////////////////////////////////////////////////////
// File includes:
#import "ASMarkerDetectionViewController.h"
#import "VideoSource.h"
#import "MarkerDetector.h"
#import "SimpleVisualizationController.h"
#import "ASVideoSelectionViewController.h"
#import "ASVideoPlayingController.h"
#import "ASData.h"
#import <Parse/Parse.h>

@interface ASMarkerDetectionViewController() <VideoSourceDelegate>

@property (strong, nonatomic) VideoSource * videoSource;
@property (nonatomic) MarkerDetector * markerDetector;
@property (strong, nonatomic) SimpleVisualizationController * visualizationController;

@end

@implementation ASMarkerDetectionViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.videoSource = [[VideoSource alloc] init];
    self.videoSource.delegate = self;
    
    self.markerDetector = new MarkerDetector([self.videoSource getCalibration], self);
    [self.videoSource startWithDevicePosition:AVCaptureDevicePositionBack];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [self setGlview:nil];
    [super viewDidUnload];
    _locationManager.delegate = nil;
    _locationManager = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.glview initContext];
    
    CGSize frameSize = [self.videoSource getFrameSize];
    CameraCalibration camCalib = [self.videoSource getCalibration];
    
    self.visualizationController = [[SimpleVisualizationController alloc] initWithGLView:self.glview
                                                                             calibration:camCalib
                                                                               frameSize:frameSize];
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Important notice:
    // Since the logical interface orientation differs from coordinate system of video frame
    // We force the interface orientation to landscape right for simplicity.
    // This orientation has one-to-one coordinates mapping from frame buffer to view.
    // So we don't have to worry about inconsistent AR.
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void) dealloc
{
    delete self.markerDetector;
}

- (void)detectMarkerWithId:(int)id
{
    if (!_isFetching) {
        _isFetching = YES;
        NSLog(@"detect marker with id %d", id);
        [ASData sharedData].markerId = id;
        _markerId = id;
        PFQuery *query = [PFQuery queryWithClassName:@"PlayBack"];
        
        // TODO: add more constraints (e.g. location)
        [query whereKey:@"markerId" equalTo:@(id)];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects.count == 0) [self performSegueWithIdentifier:@"AssignMedia" sender:self];
                else {
                    NSLog(@"videoId: %@", objects[0][@"videoId"]);
//                    UIWebView *webView = [[UIWebView alloc] initWithFrame:_glview.frame];
//                    [self.view addSubview:webView];
//                    NSString *urlString = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", objects[0][@"videoId"]];
//                    NSURL *url = [NSURL URLWithString:urlString];
//                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                    
//                    [webView loadRequest:request];
                    _videoId = objects[0][@"videoId"];
                    [self performSegueWithIdentifier:@"VideoPlaying" sender:self];
                    
                }
                _isFetching = NO;
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    }
}

#pragma mark - VideoSourceDelegate
-(void)frameReady:(BGRAVideoFrame) frame
{
    // Start upload new frame to video memory in main thread
    dispatch_sync( dispatch_get_main_queue(), ^{
        [self.visualizationController updateBackground:frame];
    });
    
    // And perform processing in current thread
    self.markerDetector->processFrame(frame);
    
    // When it's done we query rendering from main thread
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.visualizationController setTransformationList:(self.markerDetector->getTransformations)()];
        [self.visualizationController drawFrame];
    });
}

#pragma mark - Storyboard methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VideoSelection"]) {
        ASVideoSelectionViewController *vc = (ASVideoSelectionViewController *) segue.destinationViewController;
        vc.markerId = _markerId;
        vc.latitude = _location.coordinate.latitude;
        vc.longitude = _location.coordinate.longitude;
    } else if ([segue.identifier isEqualToString:@"VideoPlaying"]) {
        ASVideoPlayingController *vc = (ASVideoPlayingController *) segue.destinationViewController;
        vc.videoId = _videoId;
        vc.markerId = _markerId;
    }
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        _location = locations[0];
        [ASData sharedData].location = locations[0];
    }
}

@end
