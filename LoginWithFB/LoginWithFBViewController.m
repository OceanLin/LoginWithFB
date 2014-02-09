//
//  LoginWithFBViewController.m
//  LoginWithFB
//
//  Created by Ocean Lin on 2014/2/7.
//  Copyright (c) 2014年 PicsureHunt. All rights reserved.
//

#import "LoginWithFBViewController.h"
//FB Code Begin
#import <FacebookSDK/FacebookSDK.h>
//FB Code End

//FB Code Begin
@interface LoginWithFBViewController () <FBLoginViewDelegate>

@property (strong, nonatomic) FBLoginView *fbLoginView;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *fbProfileView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
//FB Code End

@implementation LoginWithFBViewController

#pragma mark - Initialization
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //FB Code Begin
    self.fbLoginView.frame = CGRectOffset(self.fbLoginView.frame, self.view.center.x - (self.fbLoginView.frame.size.width/2), self.view.frame.size.height - self.fbLoginView.frame.size.height - 50);
    [self.view addSubview:self.fbLoginView];
    //FB Code End
}

//FB Code Begin
- (FBLoginView *)fbLoginView
{
    if (!_fbLoginView) {
        _fbLoginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email"]];
        _fbLoginView.delegate = self;
    }
    
    return _fbLoginView;
}
//FB Code End

#pragma mark - Exception handling

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    self.fbProfileView.profileID = user.id;
    self.userNameLabel.text = user.name;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"User log in!!");
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{

    NSLog(@"User log out!!");
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Facebook session error";
        alertMessage = @"Your current session is no logger valid. Please log in again.";
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        alertTitle = @"User cancel login.";
    } else {
        alertTitle = @"FBLoginView unknown error";
        NSLog(@"Facebook Login View Error : %@", error);
    }
    
    if (alertTitle) {
        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
