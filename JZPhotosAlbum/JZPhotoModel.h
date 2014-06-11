//
//  JZPhotoModel.h
//  JZPhotosAlbum
//
//  Created by jihong zhang on 6/10/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZPhotoModel : NSObject

@property(nonatomic) NSString *sortBy;

+(id)readData;
+(id)readDataSortBy:(NSString*)sortBy;


@end
