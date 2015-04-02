//
//  ImagesCVC.m
//  Whatsapp Memes
//
//  Created by admin on 4/1/15.
//  Copyright (c) 2015 freakApps. All rights reserved.
//

#import "BaseImagesCVC.h"
#import "ImagesCVCell.h"

@interface BaseImagesCVC ()<UIDocumentInteractionControllerDelegate>

@property (retain) UIDocumentInteractionController * documentInteractionController;

@end

@implementation BaseImagesCVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ImagesCVCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.objectsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImagesCVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.contentView.frame = [cell bounds];
    
    if (self.objectsArray != nil) {
        
        PFObject *anObject = [self.objectsArray objectAtIndex:indexPath.row];
        PFFile *userImageFile = anObject[@"download"];
        
//        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//            if (!error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIImage *image = [UIImage imageWithData:imageData];
//                    cell.displayImageView.image = image;
//                    cell.backgroundColor = [UIColor yellowColor];
//                });
//            }
//        }];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Logging: %@",userImageFile.url);
            cell.displayImageView.imageURL = [NSURL URLWithString:userImageFile.url];
            cell.backgroundColor = [UIColor yellowColor];
        });
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        [self shareSelectedPhoto:indexPath];
}

- (void)shareSelectedPhoto:(NSIndexPath *)indexPath {
    
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){
        
        PFObject *anObject = [self.objectsArray objectAtIndex:indexPath.row];
        PFFile *userImageFile = anObject[@"download"];

                [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImage *iconImage = [UIImage imageWithData:imageData];
                            
                            NSString    * savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.wai"];
                            
                            [UIImageJPEGRepresentation(iconImage, 1.0) writeToFile:savePath atomically:YES];
                            
                            _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
                            _documentInteractionController.UTI = @"net.whatsapp.image";
                            _documentInteractionController.delegate = self;
                            
                            [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
                        });
                    }
                }];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
