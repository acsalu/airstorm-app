//
//  ASData.m
//  AirStorm
//
//  Created by Acsa Lu on 6/23/13.
//
//

#import "ASData.h"

NSString * const ASMediaTypeVideo = @"video";
NSString * const ASMediaTypePhoto = @"photo";
NSString * const ASMediaTypeImage = @"image";

@implementation ASData

+ (ASData *)sharedData
{
    static ASData *data;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!data) data = [[ASData alloc] init];
        data.markerId = -1;
    });
    return data;
}


@end
