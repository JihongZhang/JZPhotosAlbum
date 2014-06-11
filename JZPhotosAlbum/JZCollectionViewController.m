//
//  JZCollectionViewController.m
//  JZPhotosAlbum
//
//  Created by jihong zhang on 6/10/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZCollectionViewController.h"
#import "JZRecipeViewController.h"
#import "JZPhotoModel.h"
#import "JZPhotoItem.h"


@interface JZCollectionViewController ()
@property(nonatomic) NSArray *recipePhotos;

@end

@implementation JZCollectionViewController

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
    
    //self.recipePhotos = [JZPhotoModel readData];
    self.recipePhotos = [JZPhotoModel readDataSortBy:self.sortBy];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/* required */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recipePhotos.count;

}

/* required */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    
    JZPhotoItem *item = [[JZPhotoItem alloc]init];
    item = [self.recipePhotos objectAtIndex:indexPath.row];
    NSString *imageURL = item.imageURL;
    recipeImageView.image = [UIImage imageNamed:imageURL];
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhotoDetail"]) {
        if([segue.destinationViewController isKindOfClass:[JZRecipeViewController class]]){
            NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
            JZRecipeViewController *destViewController = segue.destinationViewController;
            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
            
            JZPhotoItem *item = [self.recipePhotos objectAtIndex:indexPath.row];       
         
            destViewController.navigationItem.title = [item.imageURL stringByDeletingPathExtension];
            destViewController.recipeImageName = item.imageURL;
            destViewController.imageTitle = item.name;
            NSString *date = [NSString stringWithFormat:@"Date: %@", item.date];
            destViewController.date = date;
            NSString *location = [NSString stringWithFormat:@"Location: %@", item.location];
            destViewController.location = location;
            NSString *author = [NSString stringWithFormat:@"Author: %@", item.author];
            destViewController.author = author;
                        
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
         
    }
}

/*async call*/
/*
-(void)resetImage
{
 //show the spinner if it is not already showing
 [self.refreshControl beginRefreshing];
 
    dispatch_queue_t imageFetchQ = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:networkURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        //back to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            //self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            //self.scrollView.contentSize = image.size;
 
            //let the user know the refreshing is over (stop spinner)
            [self.refreshControl endRefreshing];
        });
    });
}
*/
 
 
 
 
@end
