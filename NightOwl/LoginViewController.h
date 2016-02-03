//
//  LoginViewController.h
//  NightOwl
//
//  Created by Evan Nixon on 2/1/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameTopPositionConstraint;

- (IBAction)uiSignInAction:(id)sender;

@end


