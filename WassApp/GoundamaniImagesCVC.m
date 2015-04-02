//
//  GoundamaniImagesCVC.m
//  Whatsapp Memes
//
//  Created by admin on 4/1/15.
//  Copyright (c) 2015 freakApps. All rights reserved.
//

#import "GoundamaniImagesCVC.h"

@interface GoundamaniImagesCVC ()

@end

@implementation GoundamaniImagesCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
    [query whereKey:@"objectType" equalTo:[NSNumber numberWithInt:2]];
    [query whereKey:@"isReviewed" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            self.objectsArray = objects;
            [self.collectionView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
