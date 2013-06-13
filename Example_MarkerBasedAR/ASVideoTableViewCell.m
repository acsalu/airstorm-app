//
//  ASVideoTableViewCell.m
//  airstorm-app
//
//  Created by Acsa Lu on 6/8/13.
//  Copyright (c) 2013 com.nmlab.g7. All rights reserved.
//

#import "ASVideoTableViewCell.h"

@implementation ASVideoTableViewCell

@synthesize title = _title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
