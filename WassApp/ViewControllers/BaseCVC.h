//
//  ImagesCVC.h
//  Whatsapp Memes
//
//  Created by admin on 4/1/15.
//  Copyright (c) 2015 freakApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


typedef enum {
    SCREEN_MODE_TODAYS_POPULAR = 0,
    SCREEN_MODE_VADIVELU,
    SCREEN_MODE_GOUNDAMANI,
    SCREEN_MODE_OTHERS
    
} SCREEN_MODE;

@interface BaseCVC : UICollectionViewController

@property (nonatomic,strong) NSMutableArray *objectsArray;

@property (nonatomic,assign) SCREEN_MODE screenMode;

@end
