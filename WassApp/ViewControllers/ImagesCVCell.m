//
//  ImagedCVCell.m
//  Whatsapp Memes
//
//  Created by admin on 4/1/15.
//  Copyright (c) 2015 freakApps. All rights reserved.
//

#import "ImagesCVCell.h"

@implementation ImagesCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // RIGHT:
        self.displayImageView = [[AsyncImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:self.displayImageView];
    }
    return self;
}

@end
