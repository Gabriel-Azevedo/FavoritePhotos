//
//  FavoritesViewController.m
//  FavoritePhotos
//
//  Created by Gabriel Borri de Azevedo on 1/23/15.
//  Copyright (c) 2015 Gabriel Enterprises. All rights reserved.
//

#import "FavoritesViewController.h"
#import "CustomCollectionViewCell.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "Photo.h"
#import "DataManager.h"

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate>

@property NSMutableArray *favorites;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property DataManager *dataManager;

@end

@implementation FavoritesViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:nil];
    if (!self.favorites)
    {
        self.favorites = [NSMutableArray new];
    }
    self.dataManager = [DataManager new];
    self.favorites = [self.dataManager readindPlist];
    [self.collectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavCell" forIndexPath:indexPath];
    UIImage *photo = [self.favorites objectAtIndex:indexPath.row];
    cell.imageView.image = photo;
    //ERROR IS HERE
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.favorites.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.favorites removeObjectAtIndex:indexPath.row];
    [self.dataManager updatePlist:self.favorites];
    [self.collectionView reloadData];
}
 
/*-(void)Twitter
{
 UIImage *tweetImage = [UIImageView superclass];// = [self.favorites objectAtIndex:indexPath.row];
 if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
 {
 SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
 [tweetSheet setInitialText:@"Tweeting from my own app! :)"];

 [tweetSheet addImage:tweetImage];
 [self presentViewController:tweetSheet animated:YES completion:nil];
 }
 else
 {
 UIAlertView *alertView = [[UIAlertView alloc]
 initWithTitle:@"Sorry"
 message:@"You can't send a tweet right now,\n make sure your device has an internet connection \nand you have at least one Twitter account setup"
 delegate:self
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 [alertView show];
 }

}

- (IBAction)showEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"iOS programming is so fun!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}*/

@end
