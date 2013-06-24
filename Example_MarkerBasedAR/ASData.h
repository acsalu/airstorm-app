//
//  ASData.h
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString * const ASMediaTypeVideo;
extern NSString * const ASMediaTypePhoto;
extern NSString * const ASMediaTypeImage;


@interface ASData : NSObject

@property (nonatomic) int markerId;
@property (nonatomic) NSString *mediaType;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) NSString *imageURL;

+ (ASData *)sharedData;

@end
