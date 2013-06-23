//
//  ASInputSourceSelectionView.h
//  AirStorm
//
//  Created by Acsa Lu on 6/22/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ASInputSourceSelectionView : UIView

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeftGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRightGestureRecognizer;

- (void)swipeLeft;
- (void)swipeRight;

@end
