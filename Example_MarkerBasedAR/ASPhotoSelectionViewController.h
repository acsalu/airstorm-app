//
//  ASPhotoSelectionViewController.h
//  AirStorm
//
//  Created by Acsa Lu on 6/22/13.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ASCameraOverlayViewController;

@interface ASPhotoSelectionViewController:UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) ASCameraOverlayViewController *overlay;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) ALAsset *assetSelected;
@property (strong, nonatomic) UIImage *photoTook;

- (void)takePhotoFromCamera;
- (void)selectPhotoFromLibrary;
- (IBAction)launchCameraButtonPressed:(id)sender;

@end
