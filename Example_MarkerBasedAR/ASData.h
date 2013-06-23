//
//  ASData.h
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ASData : NSObject

@property (nonatomic) int markerId;
@property (strong, nonatomic) CLLocation *location;

+ (ASData *)sharedData;

@end
