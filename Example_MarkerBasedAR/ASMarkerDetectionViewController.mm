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
#import "ASDisplayMediaViewController.h"
#import "ASData.h"
#import <Parse/Parse.h>

#define THRESHOLD_DISTANCE 0.3
#define THRESHOLD_TIME_INTERVAL 3600

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
    
    self.isFetching = NO;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Loading";
    HUD.delegate = self;
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
//    NSLog(@"view will appear");
    [self.glview initContext];
    
    CGSize frameSize = [self.videoSource getFrameSize];
    CameraCalibration camCalib = [self.videoSource getCalibration];
    
    self.visualizationController = [[SimpleVisualizationController alloc] initWithGLView:self.glview
                                                                             calibration:camCalib
                                                                               frameSize:frameSize];
    self.isFetching = NO;
    
    [super viewWillAppear:animated];
}

- (void)setIsFetching:(BOOL)isFetching
{
    self.detectedOverlay.hidden = !isFetching;
    self.detectionOverlay.hidden = isFetching;
    self.instructionOverlay.hidden = isFetching;
    _isFetching = isFetching;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.visualizationController = nil;
//    self.glview = nil;
    [super viewWillDisappear:YES];
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
        self.isFetching = YES;
        NSLog(@"[Marker Detection] Detect marker with id %d", id);
        [self fetchingDataForMarkerWithId:id];
    }
}

- (void)fetchingDataForMarkerWithId:(int)markdrId
{
    [HUD show:YES];
    
    [ASData sharedData].markerId = markdrId;
    _markerId = markdrId;
    PFQuery *query = [PFQuery queryWithClassName:@"PlayBack"];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation: [ASData sharedData].location];
    // TODO: add more constraints (e.g. location)
    [query whereKey:@"markerId" equalTo:@(markdrId)];
    [query whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:THRESHOLD_DISTANCE];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *thresholdDate = [NSDate dateWithTimeInterval:-THRESHOLD_TIME_INTERVAL sinceDate:[NSDate date]];
//    NSLog(@"current time: %@", [formatter stringFromDate:[NSDate date]]);
//    NSLog(@"threshold tiem: %@", [formatter stringFromDate:thresholdDate]);
    
    [query whereKey:@"createdAt" greaterThan:thresholdDate];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSLog(@"%d objects found", objects.count);
            for (PFObject *object in objects) {
                PFGeoPoint *location = (PFGeoPoint *) object[@"location"];
                NSLog(@"[%@][%@] distance %f", object.objectId, [formatter stringFromDate:object.createdAt], [location distanceInKilometersTo:[PFGeoPoint geoPointWithLocation:[ASData sharedData].location]]);
            }
            
            
            if (objects.count == 0) [self performSegueWithIdentifier:@"AssignMedia" sender:self];
            else {
                
//                NSLog(@"[Marker Detection] Distance from object %.2f km",
//                      [objectLocation distanceInKilometersTo:[PFGeoPoint geoPointWithLocation:[ASData sharedData].location]]);
//                if (!objectLocation ||
//                    [objectLocation distanceInKilometersTo:[PFGeoPoint geoPointWithLocation:[ASData sharedData].location]] > THRESHOLD_DISTANCE) {
//                    [self performSegueWithIdentifier:@"AssignMedia" sender:self];
//                } else {
                NSDictionary *object = objects[0];
                NSString *mediaType = object[@"type"];
                
                NSLog(@"[Marker Detection] Media type: %@", mediaType);
                
                if ([mediaType isEqualToString:ASMediaTypeVideo]) {
                    [ASData sharedData].videoId = object[@"videoId"];
                    
                } else {
                    [ASData sharedData].imageURL = object[@"imageURL"];   
                }
                
                [ASData sharedData].mediaType = mediaType;
                
                [self performSegueWithIdentifier:@"DisplayMedia" sender:self];
//                }
                
            }
            [HUD hide:YES];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
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
        [vc.tabBarController setSelectedIndex:1];
    } else if ([segue.identifier isEqualToString:@"DisplayMedia"]) {
        ASDisplayMediaViewController *vc = (ASDisplayMediaViewController *) segue.destinationViewController;
        vc.navigationItem.title = [NSString stringWithFormat:@"Marker #%d", [ASData sharedData].markerId];
    }
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (![ASData sharedData].location) {
        _location = locations[0];
        [ASData sharedData].location = locations[0];
        [manager stopUpdatingLocation];
    }
}



@end
