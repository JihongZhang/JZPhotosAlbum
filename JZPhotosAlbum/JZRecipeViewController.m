//
//  JZRecipeViewController.m
//  JZPhotosAlbum
//
//  Created by jihong zhang on 6/10/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZRecipeViewController.h"

@interface JZRecipeViewController ()

@end

@implementation JZRecipeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.recipeImageView.image = [UIImage imageNamed:self.recipeImageName];
    self.lableLocation.text = self.location;
    self.lableDate.text = self.date;
    self.lableAuthor.text = self.author;
    self.lableDescription.text = self.imageDescription;
    
    self.navigationController.navigationItem.title = self.name;// imageTitle;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

/*async call*/
/*
-(void)resetImage
{
    //[self.spinner startAnimating];
    
    NSURL *imageURL = self.imageURL;
    
    dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
    dispatch_async(imageFetchQ, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //bad
        NSData *imageData =[[NSData alloc] initWithContentsOfURL:self.imageURL];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //bad
        UIImage *image =  [UIImage imageWithData:imageData];
        
        if(self.imageURL == imageURL){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image){
                    self.recipeImageView.image = image;
                }
                //[self.spinner stopAnimating];
            });
        }
    });
    
}
*/

@end
