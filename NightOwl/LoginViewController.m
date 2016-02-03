//
//  LoginViewController.m
//  NightOwl
//
//  Created by Evan Nixon on 2/1/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

bool createAccountMode = false;
int SPACE_BETWEEN_TEXT_FIELDS = 36;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutFieldsAndButtons];
}

- (void)layoutFieldsAndButtons {
    createAccountMode = false;
    _firstNameTextField.hidden = true;
    _lastNameTextField.hidden = true;
    _emailField.hidden = true;
}

- (IBAction)registerAction:(UIButton *)sender {
    if (!createAccountMode) {
        createAccountMode = true;
        [self slideLoginFieldsDown];
    } else {
        createAccountMode = false;
//        [self registerNewAccountAction];
        [self slideLoginFieldsUp];
    }
    
}

- (void)slideLoginFieldsDown {
    _firstNameTextField.hidden = false;
    _lastNameTextField.hidden = false;
    _emailField.hidden = false;
    _firstNameTextField.alpha = 0.0;
    _lastNameTextField.alpha = 0.0;
    _emailField.alpha = 0.0;
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        _firstNameTextField.alpha = 1.0;
        _lastNameTextField.alpha = 1.0;
        _emailField.alpha = 1.0;
        
        self.usernameTopPositionConstraint.constant = self.usernameTopPositionConstraint.constant + 3 *SPACE_BETWEEN_TEXT_FIELDS;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        _firstNameTextField.hidden = false;
        _lastNameTextField.hidden = false;
        _emailField.hidden = false;
        
    }];
}

- (void)slideLoginFieldsUp {
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        _firstNameTextField.alpha = 0.0;
        _lastNameTextField.alpha = 0.0;
        _emailField.alpha = 0.0;
        
        self.usernameTopPositionConstraint.constant = self.usernameTopPositionConstraint.constant - 3 *SPACE_BETWEEN_TEXT_FIELDS;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        _firstNameTextField.hidden = true;
        _lastNameTextField.hidden = true;
        _emailField.hidden = true;
    }];
}

- (void)registerNewAccountAction {
    /*
     This action will happen when the user has clicked register after the name fields
     have become visible.
     
     Actions to take here: (NOT YET COMPLETED)
     1) Verify all fields are not empty
     2) Send info to server to register a new account
     */
    if ([self isValidTextField:_firstNameTextField ] &&
        [self isValidTextField:_lastNameTextField ] &&
        [self isValidTextField:_emailField] &&
        [self isValidTextField:_usernameTextField ] &&
        [self isValidTextField:_passwordTextField ]) {
        // These fields are valid, continue adding the user!
    }
    
}
        
- (bool)isValidTextField:(UITextField *)tfield {
    return ([tfield.text length] > 0 ||
            tfield.text != nil ||
            ![tfield.text isEqual:@""]);
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

- (IBAction)uiSignInAction:(id)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.tabBarController];
}
@end
