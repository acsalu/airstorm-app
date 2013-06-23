//
//  ASPhotoSelectionViewController.m
//  AirStorm
//
//  Created by Acsa Lu on 6/22/13.
//
//

#import "ASPhotoSelectionViewController.h"
#import "ASCameraOverlayViewController.h"
#import "ASPhotoCollectionViewCell.h"
#import "ASPhotoDecideViewController.h"

@interface ASPhotoSelectionViewController ()

@end

@implementation ASPhotoSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if(asset != NULL) {
            [_assets addObject:asset];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self insertArray];
            });
        }
    };
    
    
    
    ALAssetsLibraryGroupsEnumerationResultsBlock blkListGroup = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSLog(@"%@", [group valueForProperty:ALAssetsGroupPropertyName]);
            [group enumerateAssetsUsingBlock:assetEnumerator];
            NSLog(@"%d photos", _assets.count);
//            _imageView.image = [UIImage imageWithCGImage:((ALAsset *) _assets[0]).thumbnail];
            [_collectionView reloadData];
        }
    };

    
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    [_assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:blkListGroup failureBlock:nil];
}


- (void)launchCamera
{
 
    _picker = [[UIImagePickerController alloc] init];
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    _picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//    _picker.showsCameraControls = NO;
//    _picker.navigationBarHidden = YES;
//    _picker.toolbarHidden = YES;
//    _picker.wantsFullScreenLayout = YES;
    
    _overlay = [[ASCameraOverlayViewController alloc] initWithNibName:@"ASCameraOverlayViewController" bundle:nil];
    
    _overlay.picker = _picker;
//    _picker.cameraOverlayView = _overlay.view;
    
    [self presentViewController:_picker animated:NO completion:NULL];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (IBAction)takePhoto:(id)sender
{

}

- (IBAction)choosePhoto:(id)sender {
}
- (IBAction)launchCameraButtonPressed:(id)sender {
    [self launchCamera];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assets.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ASPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithCGImage:((ALAsset *)_assets[_assets.count - indexPath.row - 1]).thumbnail];
    
    return cell;
}

#pragma mark -UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _assetSelected = _assets[_assets.count - indexPath.row - 1];
    [self performSegueWithIdentifier:@"DecidePhoto" sender:self];
}

#pragma mark - StoryBoard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DecidePhoto"]) {
        ASPhotoDecideViewController *vc = (ASPhotoDecideViewController *) segue.destinationViewController;
        
        UIImageOrientation orientation = UIImageOrientationUp;
        
        NSNumber* orientationValue = [_assetSelected    valueForProperty:@"ALAssetPropertyOrientation"];
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        
        vc.image = [UIImage imageWithCGImage:_assetSelected.defaultRepresentation.fullResolutionImage scale:1.0f orientation:orientation];
    }
}


@end
