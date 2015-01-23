//
//  ViewController.m
//  FavoritePhotos
//
//  Created by Gabriel Borri de Azevedo on 1/22/15.
//  Copyright (c) 2015 Gabriel Enterprises. All rights reserved.
//

#import "RootViewController.h"
#import "Photo.h"
#import "CustomCollectionViewCell.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSArray *photosInfoArray;
@property NSMutableArray *photosArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosArray = [NSMutableArray new];
    [self searchedTerm];
}

-(void)searchedTerm
{
    //NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%20c14a555c10ce476191359def63de16ff", self.searchField.text];
    NSString *urlString = @"https://api.instagram.com/v1/tags/snow/media/recent?client_id=%20c14a555c10ce476191359def63de16ff";

    NSURL *url = [NSURL URLWithString:urlString]; // URL of Meetup.com's API

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url]; //request from URL

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) // start connection
     {
         NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]; // Dict of JSON
         self.photosInfoArray = [JSON objectForKey:@"data"]; // Array of JSON's Dict

//         for (NSDictionary *photoInfo in self.photosInfoArray) // for each event in resultsArray
         for (int i = 0; i < 2; i++) // for each event in resultsArray
         {
             NSLog(@"photo %i",i);
             Photo *photo = [Photo new];

             NSDictionary *images = [[self.photosInfoArray objectAtIndex:i] objectForKey:@"images"];
             NSDictionary *standardPhotoInfo = [images objectForKey:@"standard_resolution"];
             NSString *standardPhotoURL = [standardPhotoInfo objectForKey:@"url"];

             photo.standardPhoto = standardPhotoURL;

            [self.photosArray addObject:photo];
         }
         [self.collectionView reloadData];
     }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Photo *photo =[self.photosArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:photo.standardPhoto];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    cell.image = image;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}




@end
