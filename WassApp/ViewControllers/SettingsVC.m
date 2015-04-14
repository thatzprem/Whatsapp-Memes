//
//  OthersCVC.m
//  Whatsapp Memes
//
//  Created by admin on 4/5/15.
//  Copyright (c) 2015 freakApps. All rights reserved.
//

#import "SettingsVC.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface SettingsVC()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation SettingsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Settings";
    
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
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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
