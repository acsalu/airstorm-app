//
//  ASInputSourceSelectionView.m
//  AirStorm
//
//  Created by Acsa Lu on 6/22/13.
//
//

#import "ASInputSourceSelectionView.h"

@implementation ASInputSourceSelectionView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        
        _swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
        _swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
 
        _swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        _swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        
        [self addGestureRecognizer:_swipeLeftGestureRecognizer];
        [self addGestureRecognizer:_swipeRightGestureRecognizer];
    }
    return self;
}


@end
