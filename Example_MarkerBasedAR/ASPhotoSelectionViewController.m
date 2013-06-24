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
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
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

- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)launchCamera
{
 
    _picker = [[UIImagePickerController alloc] init];
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    _picker.delegate = self;
    
    [self presentViewController:_picker animated:YES completion:NULL];
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
    if (indexPath.row == 0)
        cell.imageView.image = [UIImage imageNamed:@"camera-button-normal"];
    else
        cell.imageView.image = [UIImage imageWithCGImage:((ALAsset *)_assets[_assets.count - indexPath.row]).thumbnail];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self launchCamera];
    } else {
        _assetSelected = _assets[_assets.count - indexPath.row];
        [self performSegueWithIdentifier:@"DecidePhoto" sender:self];
    }
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    _photoTook = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%.0f x %.0f", _photoTook.size.height, _photoTook.size.width);
    [self performSegueWithIdentifier:@"TookPhoto" sender:self];
}

#pragma mark - StoryBoard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DecidePhoto"]) {
        ASPhotoDecideViewController *vc = (ASPhotoDecideViewController *) segue.destinationViewController;
        
        UIImageOrientation orientation = UIImageOrientationUp;
        
        NSNumber* orientationValue = [_assetSelected valueForProperty:@"ALAssetPropertyOrientation"];
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        
        vc.image = [UIImage imageWithCGImage:_assetSelected.defaultRepresentation.fullResolutionImage scale:1.0f orientation:orientation];
    } else if ([segue.identifier isEqualToString:@"TookPhoto"]) {
        ASPhotoDecideViewController *vc = (ASPhotoDecideViewController *) segue.destinationViewController;
        vc.image = _photoTook;
    }
}

@end
