/*****************************************************************************
*   ViewController.h
*   Example_MarkerBasedAR
******************************************************************************
*   by Khvedchenia Ievgen, 5th Dec 2012
*   http://computer-vision-talks.com
******************************************************************************
*   Ch2 of the book "Mastering OpenCV with Practical Computer Vision Projects"
*   Copyright Packt Publishing 2012.
*   http://www.packtpub.com/cool-projects-with-opencv/book
*****************************************************************************/

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EAGLView.h"

@interface ASMarkerDetectionViewController : UIViewController<CLLocationManagerDelegate>
{
}

@property (weak, nonatomic) IBOutlet EAGLView *glview;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) int markerId;
@property (nonatomic) BOOL isFetching;

- (void)detectMarkerWithId:(int)id;

@end
