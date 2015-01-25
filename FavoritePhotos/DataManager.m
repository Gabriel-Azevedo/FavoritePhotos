//
//  DataManager.m
//  FavoritePhotos
//
//  Created by Gabriel Borri de Azevedo on 1/25/15.
//  Copyright (c) 2015 Gabriel Enterprises. All rights reserved.
//

#import "DataManager.h"
#import "Photo.h"

@implementation DataManager

-(void)updatePlist:(NSMutableArray *)favoritesArray
{
    NSMutableArray *temp = [NSMutableArray new];

    for (UIImage *photo in favoritesArray)
    {
        NSData *imageData = UIImageJPEGRepresentation(photo, 1);
        NSDictionary *newPhoto = [NSDictionary dictionaryWithObject:imageData forKey:@"imageData"];
        [temp addObject:newPhoto];
    }

    NSError *anotherError;
    NSData *serializedData = [NSPropertyListSerialization dataWithPropertyList:temp format:NSPropertyListBinaryFormat_v1_0 options:0 error:&anotherError]; //creating data with array

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documents = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    documents = [documents URLByAppendingPathComponent:@"photos.plist"];

    BOOL success = [serializedData writeToURL:documents atomically:YES];
    if (success)
    {
        NSLog(@"Sucess");
    }
    else
    {
        NSLog(@"Error");
    }
}

-(NSMutableArray *)readindPlist
{
    NSMutableArray *favorites = [NSMutableArray new];
    NSString *properListPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    properListPath = [properListPath stringByAppendingString:@"/photos.plist"];

    NSData *plistData = [[NSFileManager defaultManager] contentsAtPath:properListPath];
    NSError *error;
    NSArray *photoArray = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:nil error:&error];
    if (photoArray)
    {
        for (NSDictionary *photoImage in photoArray)
        {
            NSData *data = photoImage[@"imageData"];
            UIImage *photo = [UIImage imageWithData:data];
            [favorites addObject:photo];
        }
    }
    else
    {
        NSLog(@"Error: %@",error);
    }
    return favorites;
}
@end
