//
//  TextTVC.m
//  WassApp
//
//  Created by admin on 3/31/15.
//  Copyright (c) 2015 freakApps. All rights reserved.
//

#import "TextTVC.h"
#import <Parse/Parse.h>

@interface TextTVC()

@property (nonatomic,strong) NSArray *objectsArray;

@end

@implementation TextTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDataFromServer];
}

- (void)getDataFromServer {
    
    PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
    [query whereKey:@"objectType" equalTo:[NSNumber numberWithInt:0]];
    [query whereKey:@"isReviewed" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            self.objectsArray = objects;
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.objectsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    if (self.objectsArray != nil) {
        
        PFObject *anObject = [self.objectsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = anObject[@"titleName"];
        cell.detailTextLabel.text = anObject[@"titleDescription"];

        PFFile *userImageFile = anObject[@"download"];

        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                cell.imageView.image = image;
            }
        }];

    }
    return cell;
}

@end
