//
//  DataManager.h
//  FavoritePhotos
//
//  Created by Gabriel Borri de Azevedo on 1/25/15.
//  Copyright (c) 2015 Gabriel Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

-(void)updatePlist:(NSMutableArray *)favoritesArray;

-(NSMutableArray *)readindPlist;

@end
