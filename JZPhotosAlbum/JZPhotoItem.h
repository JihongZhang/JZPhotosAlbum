//
//  JZPhotoItem.h
//  JZPhotosAlbum
//
//  Created by jihong zhang on 6/10/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZPhotoItem : NSObject

@property (nonatomic) int  photoId;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * imageDescription;
@property (nonatomic) int  isRemote;
@property (nonatomic, retain) NSString * author;

@end
