//
//  JZPhotoModel.m
//  JZPhotosAlbum
//
//  Created by jihong zhang on 6/10/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZPhotoModel.h"
#import <sqlite3.h>
#import "JZPhotoItem.h"


@implementation JZPhotoModel

NSString * const myDataBase = @"photoTestDB";
sqlite3 *photoDb = nil;


#pragma mark readData
+(id)readData
{
    NSMutableArray *photoData = [[NSMutableArray alloc] init];
    photoData = [self readDataFromDB];
    if(photoData.count==0){
        photoData = [self paserData:@"photo.json"];
    }
    
    return photoData;
    
}

+(id)readDataSortBy:(NSString*)sortBy
{
    NSMutableArray *photoData = [[NSMutableArray alloc] init];
    photoData = [self readDataFromDBSortBy:sortBy];
    if(photoData.count==0){
        photoData = [self paserData:@"photo.json"];
        photoData = [self readDataFromDBSortBy:sortBy];
    }
    
    return photoData;
    
}


+(id)readDataAndSortBy:(NSString *)sortBy
{
    NSMutableArray *photoData = [[NSMutableArray alloc] init];
    photoData = [self readDataFromDB];
    if(photoData.count==0){
        photoData = [self paserData:@"photo.json"];
        if(sortBy != (id)[NSNull null]){
            
        }
    }
    
    return photoData;
    
}

#pragma mark paserData
+(id)paserData:(NSString *)fileName
{
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *path = [resourcePath stringByAppendingPathComponent:fileName];
    NSData *data =[NSData dataWithContentsOfFile:path];
    
    //get data from json file
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    NSArray *photoArray = [jsonData objectForKey:@"photos"];
    
    NSMutableArray *allData = [[NSMutableArray alloc] init];
    for(int i=0; i< photoArray.count; i++){
        
        NSDictionary *photo = [photoArray objectAtIndex:i];
        JZPhotoItem *photoItem = [[JZPhotoItem alloc] init];
        
        photoItem.photoId = [[photo objectForKey:@"photoId"] integerValue];
        photoItem.isRemote = [[photo objectForKey:@"isRemote"] integerValue];
        photoItem.name = [photo objectForKey:@"name"];
        photoItem.imageURL = [photo objectForKey:@"imageURL"];
        photoItem.date = [photo objectForKey:@"date"];
        photoItem.location = [photo objectForKey:@"location"];
        photoItem.imageDescription = [photo objectForKey:@"imageDescription"];
        photoItem.author = [photo objectForKey:@"author"];        
        
        [allData addObject:photoItem];        
    }
    
    [self insertPhotoData:(NSMutableArray*)allData];
    return allData;
}



#pragma mark readDataFromDB
+(NSMutableArray *)readDataFromDB
{
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
    [self openDatabase];
    int photoCount = [self getPhotoCountFromPhotoTable];
    if(photoCount == 0){
        //no data, need to read data from Json file
        //make the tables ready for the new data, and then read data from Json file
        char *sqlDropPhotoTable = "DROP TABLE IF EXISTS t_photo;";
        [self execDbSQL:sqlDropPhotoTable];
        return tableData;
    }
    
    //data is ready in the database
    //get photo data
    tableData = [self getPhotoInfoFromTable];
    return tableData;
}

+(NSMutableArray *)readDataFromDBSortBy:(NSString *)sortBy
{
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
    [self openDatabase];
    int photoCount = [self getPhotoCountFromPhotoTable];
    if(photoCount == 0){
        //no data, need to read data from Json file
        //make the tables ready for the new data, and then read data from Json file
        char *sqlDropPhotoTable = "DROP TABLE IF EXISTS t_photo;";
        [self execDbSQL:sqlDropPhotoTable];
        return tableData;
    }
    
    //data is ready in the database
    //get photo data
    tableData = [self getPhotoInfoFromTableSortBy:sortBy];
    return tableData;
}


/* this is interal commen function for all the drop table functions
 */
+(void)execDbSQL:(char*)sql
{
    char *errorMsg;
    if (sqlite3_exec(photoDb, sql, NULL, NULL, &errorMsg) != SQLITE_OK){
        NSLog(@"Error: %s", errorMsg);
    }else{
        NSLog(@"%s",sql);
    }
}

#pragma mark getPhotoCountFromPhotoTable
+(int)getPhotoCountFromPhotoTable;
{
    int count = 0;
    sqlite3_stmt *stmt;
    char *sql = "select count(*) from t_photo;";
    int returnStatus = sqlite3_prepare_v2(photoDb, sql, -1, &stmt, NULL);
    if((returnStatus == SQLITE_NOTFOUND) || (returnStatus == SQLITE_NULL)){
        return 0; //no data
    }else{
        if (sqlite3_step(stmt) == SQLITE_ROW){
            count = sqlite3_column_int(stmt, 0);
        }
    }
    return count;
}

#pragma mark get photo info from t_photo
+(NSMutableArray*)getPhotoInfoFromTable
{
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    char *sql = "select photoId, name, imageURL, isRemote, location, imageDescription, author, date from t_photo;";
    int returnStatus = sqlite3_prepare_v2(photoDb, sql, -1, &stmt, NULL);
    if((returnStatus == SQLITE_NOTFOUND) || (returnStatus == SQLITE_NULL)){
        return tableData; //no data
    }else{
        while (sqlite3_step(stmt) == SQLITE_ROW){
            int photoId = sqlite3_column_int(stmt, 0);
            char *name = (char *)sqlite3_column_text(stmt, 1);
            char *imageURL = (char *)sqlite3_column_text(stmt, 2);
            int isRemote = sqlite3_column_int(stmt, 3);
            char *location = (char *)sqlite3_column_text(stmt, 4);
            char *imageDescription = (char *)sqlite3_column_text(stmt, 5);
            char *author = (char *)sqlite3_column_text(stmt, 6);
            char *myDate = (char *)sqlite3_column_text(stmt, 7);
 
            //get product basic info from t_products
            JZPhotoItem *item = [[JZPhotoItem alloc] init];
            item.photoId = photoId;  
            item.isRemote = isRemote;   
            item.name =  [[NSString alloc] initWithUTF8String:name];
            item.imageURL =  [[NSString alloc] initWithUTF8String:imageURL];
            item.location=  [[NSString alloc] initWithUTF8String:location];
            item.imageDescription =  [[NSString alloc] initWithUTF8String:imageDescription];
            item.author =  [[NSString alloc] initWithUTF8String:author];
            item.date =  [[NSString alloc] initWithUTF8String:myDate];

            [tableData addObject:item];
        }
    }
    return tableData;
}

#pragma mark get photo info from t_photo
+(NSMutableArray*)getPhotoInfoFromTableSortBy:(NSString*)sortBy
{
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    const char *sql;
 
    if(sortBy == (id)(id)[NSNull null]){
        sql = "select photoId, name, imageURL, isRemote, location, description, author, tookDate from t_photo;";
    }else{
        NSString *queryString = [NSString stringWithFormat:@"select photoId, name, imageURL, isRemote, location, description, author, tookDate from t_photo order by %@;", sortBy ];
        sql = [queryString UTF8String];
    }

    //sql = "select photoId, name, imageURL, isRemote, location, description, author, tookDate from t_photo;";
    
    
    int returnStatus = sqlite3_prepare_v2(photoDb, sql, -1, &stmt, NULL);
    if((returnStatus == SQLITE_NOTFOUND) || (returnStatus == SQLITE_NULL)){
        return tableData; //no data
    }else{
        while (sqlite3_step(stmt) == SQLITE_ROW){
            int photoId = sqlite3_column_int(stmt, 0);
            char *name = (char *)sqlite3_column_text(stmt, 1);
            char *imageURL = (char *)sqlite3_column_text(stmt, 2);
            int isRemote = sqlite3_column_int(stmt, 3);
            char *location = (char *)sqlite3_column_text(stmt, 4);
            char *imageDescription = (char *)sqlite3_column_text(stmt, 5);
            char *author = (char *)sqlite3_column_text(stmt, 6);
            char *myDate = (char *)sqlite3_column_text(stmt, 7);
            
            //get product basic info from t_products
            JZPhotoItem *item = [[JZPhotoItem alloc] init];
            item.photoId = photoId;
            item.isRemote = isRemote;
            item.name =  [[NSString alloc] initWithUTF8String:name];
            item.imageURL =  [[NSString alloc] initWithUTF8String:imageURL];
            item.location=  [[NSString alloc] initWithUTF8String:location];
            item.imageDescription =  [[NSString alloc] initWithUTF8String:imageDescription];
            item.author =  [[NSString alloc] initWithUTF8String:author];
            item.date =  [[NSString alloc] initWithUTF8String:myDate];
            
            [tableData addObject:item];
        }
    }
    return tableData;
}


#pragma mark - insert data to DB
#pragma mark inserphotoData
+(void) insertPhotoData:(NSMutableArray*)photoAllData
{
    [self openDatabase];
    [self createPhotoTables];
    
    for(int i=0; i< photoAllData.count; i++){
        JZPhotoItem *photoItem = [[JZPhotoItem alloc] init];
        photoItem = photoAllData[i];
        
        //insert Photo data into database
        [self insertPhotoId:(int)photoItem.photoId name:(NSString*)photoItem.name imageURL:(NSString*)photoItem.imageURL isRemote:(int)photoItem.isRemote location:(NSString*)photoItem.location description:(NSString*)photoItem.imageDescription author:(NSString*)photoItem.author date:(NSString*)photoItem.date];
    }
}


#pragma mark photo item to DB
/** Insert Photo infomation to t_photo table
 *  the main info are:
 *  photoId, name, imageURL, isRemote, location, imageDescription, author, date
 */
+(void)insertPhotoId:(int)photoId name:(NSString*)name imageURL:(NSString*)imageURL isRemote:(int)isRemote location:(NSString*)location description:(NSString*)imageDescription author:(NSString*)author date:(NSString*)date
{
    sqlite3_stmt *stmt;
    if(photoId <= 0){
        NSLog(@"Table insert failed, invalid photoId");
        return;
    }
    
    char *sql = "insert into t_photo(photoId, name, imageURL, isRemote, location, description, author, tookDate) values(?, ?, ?, ?, ?, ?, ?, ?);";
    int prepareStatus = sqlite3_prepare_v2(photoDb, sql, -1, &stmt, NULL);
    if(prepareStatus == SQLITE_OK){ //if no error
        //binding
        int i = 1;
        sqlite3_bind_int(stmt, i++, photoId); // photoId, field
        if(name == (id)[NSNull null]){
            name = @"";
        }
        sqlite3_bind_text(stmt, i++, [name UTF8String], -1, NULL); //name field
        if(imageURL == (id)[NSNull null]){
            imageURL = @"";
        }
        sqlite3_bind_text(stmt, i++, [imageURL UTF8String], -1, NULL);   //imageURL
        sqlite3_bind_int(stmt, i++, isRemote);
        if(location == (id)[NSNull null]){
            location = @"";
        }
        sqlite3_bind_text(stmt, i++, [location UTF8String], -1, NULL);
        if(imageDescription == (id)[NSNull null]){
            imageDescription = @"";
        }
        sqlite3_bind_text(stmt, i++, [imageDescription UTF8String], -1, NULL);
        if(author == (id)[NSNull null]){
            author = @"";
        }
        sqlite3_bind_text(stmt, i++, [author UTF8String], -1, NULL);
        if(date == (id)[NSNull null]){
            date = @"";
        }
        sqlite3_bind_text(stmt, i, [date UTF8String], -1, NULL);
        //insert
        if(sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"Table insert failed");
        }
        //release stmt
        sqlite3_finalize(stmt);
        NSLog(@"INSERT: %s", sql);
    }else{
        NSLog(@"insert sql prepare error");
    }
}


#pragma mark createphotoTables
/** Tables name and fiels:
 table of t_photo:
 photoId(primary key), name text, imageURL text, isRemote int, date text, location text, description text, author text
 */

+(void)createPhotoTables{
    char *sql = "create table if not exists t_photo(photoId integer primary key AUTOINCREMENT, name text, imageURL text, isRemote int, location text, description text, author text, tookDate text);";
    char *error;
    int execStatus = sqlite3_exec(photoDb, sql, NULL, NULL, &error);
    if(execStatus != SQLITE_OK){
        NSLog(@"Table t_photo create error: %s", error);
    }else{
        NSLog(@"Table t_photo create sucessful");
    }
}

#pragma mark openDatabase
+(void)openDatabase{
    if(photoDb != nil)
        return;
    
    NSString *documentsRootDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dbPath = [documentsRootDir stringByAppendingPathComponent:myDataBase];
    int dbOpenStatus = sqlite3_open([dbPath UTF8String], &photoDb);
    if(dbOpenStatus != SQLITE_OK){
        NSLog(@"Database open failed");
    }else{
        NSLog(@"Database open success");
    }
}



@end
