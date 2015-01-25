//
//  ViewController.m
//  FavoritePhotos
//
//  Created by Gabriel Borri de Azevedo on 1/22/15.
//  Copyright (c) 2015 Gabriel Enterprises. All rights reserved.
//

#import "Photo.h"
#import "DataManager.h"
#import "RootViewController.h"
#import "CustomCollectionViewCell.h"
#import "FavoritesViewController.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UITabBarControllerDelegate, UITabBarDelegate>

@property NSArray *photosInfoArray;
@property NSMutableArray *rawPhotosArray;
@property NSMutableArray *photos;
@property NSMutableArray *favoritesArray;
@property FavoritesViewController *favVC;
@property NSInteger count;
@property DataManager *dataManager;
@property (weak, nonatomic) IBOutlet UIImageView *heartIcon;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rawPhotosArray = [NSMutableArray new];
    self.favoritesArray = [NSMutableArray new];
    self.photos = [NSMutableArray new];
    self.dataManager = [DataManager new];
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.favoritesArray containsObject:[self.photos objectAtIndex:indexPath.row]])
    {
        self.count++;
        Photo *photo =[self.photos objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:photo.standardPhoto];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        photo.isFavorite = TRUE;
        [self.favoritesArray addObject:image];
        [self.dataManager updatePlist:self.favoritesArray];
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%li", (long)self.count]];
    }
    else
    {
        self.count--;
        Photo *photo = [self.photos objectAtIndex:indexPath.row];
        photo.isFavorite = FALSE;
        [self.favoritesArray removeObject:photo];
        [self.dataManager updatePlist:self.favoritesArray];

        if (!self.count == 0)
        {
            [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%li", (long)self.count]];
        }
        else
        {
            [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:nil];
        }
    }

    [self.collectionView reloadData];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.photos = [NSMutableArray new];
    NSString *urlString;
    if (searchBar.selectedScopeButtonIndex == 0)
    {

        NSString *userID = @"%20c14a555c10ce476191359def63de16ff";
        urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@", searchBar.text, userID];
        [self searchedTerm:urlString];
    }
    else
    {
        NSString *userID = @"%20c14a555c10ce476191359def63de16ff";
        urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/search?q=%@&client_id=%@", searchBar.text, userID];
        [self searchUser:urlString];
    }
    [searchBar resignFirstResponder];
}

-(void)searchedTerm:(NSString *)term
{
    NSURL *url = [NSURL URLWithString:term]; // URL of Meetup.com's API

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url]; //request from URL

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) // start connection
     {
         NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]; // Dict of JSON
         self.photosInfoArray = [JSON objectForKey:@"data"]; // Array of JSON's Dict

         for (int i = 0; i < 10; i++) // for each event in resultsArray
         {
             Photo *photo = [Photo new];

             NSDictionary *images = [[self.photosInfoArray objectAtIndex:i] objectForKey:@"images"];
             NSDictionary *standardPhotoInfo = [images objectForKey:@"standard_resolution"];
             NSString *standardPhotoURL = [standardPhotoInfo objectForKey:@"url"];


             photo.standardPhoto = standardPhotoURL;

             [self.photos addObject:photo];
         }
         [self.collectionView reloadData];
     }];
}

-(void)searchUser:(NSString *)user
{
    NSURL *url = [NSURL URLWithString:user]; // URL of Meetup.com's API

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url]; //request from URL

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) // start connection
     {
         NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]; // Dict of JSON
         self.photosInfoArray = [JSON objectForKey:@"data"]; // Array of JSON's Dict

         for (int i = 0; i < 10; i++) // for each event in resultsArray
         {
             Photo *photo = [Photo new];

             NSString *userImage = [[self.photosInfoArray objectAtIndex:i] objectForKey:@"profile_picture"];

             photo.standardPhoto = userImage;

             [self.photos addObject:photo];
         }
         [self.collectionView reloadData];
     }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Photo *photo =[self.photos objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:photo.standardPhoto];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    if (photo.isFavorite)
    {
        cell.heartIcon.hidden = FALSE;
    }
    else
    {
        cell.heartIcon.hidden = TRUE;
    }
    cell.imageView.image = image;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

@end
