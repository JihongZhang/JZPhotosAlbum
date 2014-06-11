//
//  JZRecipeViewController.h
//  JZPhotosAlbum
//
//  Created by jihong zhang on 6/10/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZPhotoItem.h"

@interface JZRecipeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property(nonatomic, weak) NSString *recipeImageName;
@property (weak, nonatomic) IBOutlet UILabel *lableDate;
@property (weak, nonatomic) IBOutlet UILabel *lableLocation;
@property (weak, nonatomic) IBOutlet UILabel *lableDescription;
@property (weak, nonatomic) IBOutlet UILabel *lableAuthor;

@property (weak, nonatomic)  NSString *imageTitle;


@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSString *imageDescription;
@property(nonatomic, strong) NSString *author;


@property(nonatomic) NSURL *imageURL;   


@end
