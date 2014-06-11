//
//  JZPhotoAlbumFirstPage.m
//  JZPhotosAlbum
//
//  Created by jihong zhang on 6/10/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZPhotoAlbumFirstPage.h"
#import "JZCollectionViewController.h"
#import "JZCheckBox.h"


@interface JZPhotoAlbumFirstPage ()

@property(nonatomic) JZCheckBox *checkBoxAuthor;
@property(nonatomic) JZCheckBox *checkBoxTitle;
@property(nonatomic) JZCheckBox *checkBoxDesc;


@end

@implementation JZPhotoAlbumFirstPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define myMargin  50
#define myLableHeight 30
#define myCheckBoxWidth 200


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat lableX = myMargin;
    CGFloat lableY = screenHeight/3;
    CGFloat lableWidth = screenWidth - myMargin*2;
    CGFloat lableHeight = myLableHeight;
    UILabel *lableSortBy = [[UILabel alloc] initWithFrame:CGRectMake(lableX, lableY, lableWidth, lableHeight)];
    lableSortBy.text = @"Sort by:";
    [self.view addSubview:lableSortBy];
    
    CGFloat checkX = lableX;
    CGFloat checkY = lableY + myLableHeight;
    CGFloat checkWidth = myCheckBoxWidth;
    CGFloat checkHeight = myLableHeight;
    CGRect frame = CGRectMake(checkX, checkY, checkWidth, checkHeight);
    self.checkBoxTitle = [[JZCheckBox alloc] initWithTitle:@"Title (default)" andFrame:frame andState:TRUE];
    self.checkBoxTitle.delegate = self;
    [self.view addSubview:self.checkBoxTitle];
    
    CGFloat checkX2 = lableX;
    CGFloat checkY2 = checkY + myLableHeight;
    CGFloat checkWidth2 = myCheckBoxWidth;
    CGFloat checkHeight2 = myLableHeight;
    frame = CGRectMake(checkX2, checkY2, checkWidth2, checkHeight2);
    self.checkBoxAuthor = [[JZCheckBox alloc] initWithTitle:@"Author" andFrame:frame];
    self.checkBoxAuthor.delegate = self;
    [self.view addSubview:self.checkBoxAuthor];

    
    CGFloat checkX3 = lableX;
    CGFloat checkY3 = checkY2 + myLableHeight;
    CGFloat checkWidth3 = myCheckBoxWidth;
    CGFloat checkHeight3 = myLableHeight;
    frame = CGRectMake(checkX3, checkY3, checkWidth3, checkHeight3);
    self.checkBoxDesc  = [[JZCheckBox alloc] initWithTitle:@"Desc (default is Asc)" andFrame:(CGRect)frame];
    self.checkBoxDesc.delegate = self;
    [self.view addSubview:self.checkBoxDesc];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JZCheckBox delegate
-(void) onCheckBoxChange:(JZCheckBox *)checkBox isChecked:(BOOL)isChecked
{
    //add code to handle the event for check box state change
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAllPhotos"]) {
        if([segue.destinationViewController isKindOfClass:[JZCollectionViewController class]]){
            JZCollectionViewController *destViewController = segue.destinationViewController;
        
            NSMutableString * sortBy = [[NSMutableString alloc] init];
            NSMutableString *author = [[NSMutableString alloc] initWithString:@"Author"];
            NSMutableString *title = [[NSMutableString alloc] initWithString:@"name"];
            
            
            if([self.checkBoxAuthor isChecked]){
                if(![self.checkBoxTitle isChecked]){
                    [sortBy appendString:[NSString stringWithFormat:@"%@, %@", author, title]];
                }else{
                    [sortBy appendString:[NSString stringWithFormat:@"%@, %@",  title, author]];
                }
            }else{
                [sortBy appendString:[NSString stringWithFormat:@"%@, %@",  title, author]];
            }
            if([self.checkBoxDesc isChecked]){
                [sortBy appendString:[NSString stringWithFormat:@" %s", "DESC"]];
            }else{
                [sortBy appendString:[NSString stringWithFormat:@" %s", "ASC"]];
            }
            destViewController.sortBy = sortBy;

        }
        
    }
}


@end
