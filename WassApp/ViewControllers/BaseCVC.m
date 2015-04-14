//
//  ImagesCVC.m
//  Whatsapp Memes
//
//  Created by admin on 4/1/15.
//  Copyright (c) 2015 freakApps. All rights reserved.
//

#import "BaseCVC.h"
#import "ImagesCVCell.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>

@interface BaseCVC ()<UIDocumentInteractionControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (retain) UIDocumentInteractionController * documentInteractionController;
@property (nonatomic,strong)  MFMailComposeViewController *mailComposer;

@end

@implementation BaseCVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[ImagesCVCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //Adding refresh button.
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(refreshButtonPressed)];
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    
    //Load data
    [self fetchNewData];
}

- (void)fetchNewData {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";

    PFQuery *query = [PFQuery queryWithClassName:kParseTableName];
    [query whereKey:@"objectType" equalTo:[NSNumber numberWithInt:self.screenMode]];
    
    [query whereKey:@"isReviewed" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES]; //Remove activity indicator
            if (!error) {
                // The find succeeded. The first 100 objects are available in objects
                self.objectsArray = [NSMutableArray arrayWithArray:objects];
                [self.collectionView reloadData];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
                [[[UIAlertView alloc] initWithTitle:@"Info" message:@"The Internet connection appears to be offline. Please check your network settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
        });
    }];
    
}
- (void)refreshButtonPressed {
//    [self fetchNewData];
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Help us get better!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Upload memes",
                            @"Leave us feedback",
                            @"Rate us on iTunes",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) { //Share
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self selectPhoto:nil];
                    
                    break;
                case 1:
                    [self sendMail:nil];
                    
                    break;
                case 2:
                    [self rateSouthRadios];
                    
                    break;
                case 3:
                    //
                    
                    break;
                case 4:
                    //
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
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
    return 1;
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";

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
                            
                            [hud hide:YES]; //Remove activity indicator

                            [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
                        });
                    }
                }];
    } else {
        [hud hide:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	return NO;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	
//}

#pragma mark - send email.

-(void)sendMail:(id)sender{
    self.mailComposer = [[MFMailComposeViewController alloc]init];
    self.mailComposer.mailComposeDelegate = self;
    [self.mailComposer setSubject:[NSString stringWithFormat:@"Feedback: iOS v%@",[self appVersion]]];
    [self.mailComposer setToRecipients:@[@"thatzprem@gmail.com"]];
    
    //    [self.mailComposer setMessageBody:@"Testing message for the test mail" isHTML:NO];
    [self presentViewController:self.mailComposer animated:YES completion:nil];
}

#pragma mark - mail compose delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result == MFMailComposeResultSent) {
        
        NSLog(@"Result : %d",result);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Thank you for your continued support and feedback. We are working on to make this product better." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self.mailComposer dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *) appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

- (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self build];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}


- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
        NSData *imageData = UIImagePNGRepresentation(chosenImage);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        
        PFObject *userPhoto = [PFObject objectWithClassName:kParseTableName];
        userPhoto[kParseTableTitle] = @"My trip to Hawaii!";
        userPhoto[kParseTableImage] = imageFile;
        [userPhoto saveInBackground];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Thank you for submitting the images. We will review the images and enable it for public" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];

    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rateSouthRadios{
    
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
    
    NSString *finalURL = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, kiTunesAppID];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalURL]];
    
}

@end
