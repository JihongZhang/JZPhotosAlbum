//
//  JZPhotoItem.m
//  JZPhotosAlbum
//
//  Created by jihong zhang on 6/10/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZPhotoItem.h"

@implementation JZPhotoItem

-(void)setPhotoItem:(JZPhotoItem*)item
{
    self.imageURL = item.imageURL;
    self.imageDescription = item.imageDescription;
    self.name = item.name;
    self.location = item.location;
    self.author = item.author;
}

-(JZPhotoItem*)getPhotoItem
{
    return self;
}


@end
