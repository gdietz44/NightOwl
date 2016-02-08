//
//  LoginViewController.m
//  NightOwl
//
//  Created by Evan Nixon on 2/1/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

bool createAccountMode = false;
int SPACE_BETWEEN_TEXT_FIELDS = 36;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailField.delegate = self;
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
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
        if([self allFieldsValid]) {
            [self registerNewAccountAction];
        } else {
            [self slideLoginFieldsUp];
        }
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

    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailField.text;
    
    // other fields can be set just like with PFObject
    user[@"firstName"] = self.firstNameTextField.text;
    user[@"lastName"] = self.lastNameTextField.text;
    user[@"currentClasses"] = @[];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate.window setRootViewController:appDelegate.tabBarController];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"There was an error registering." message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}

- (bool)isValidTextField:(UITextField *)tfield {
    return ([tfield.text length] > 0 ||
            tfield.text != nil ||
            ![tfield.text isEqual:@""]);
}

- (BOOL)allFieldsValid {
    return ([self isValidTextField:_firstNameTextField ] &&
    [self isValidTextField:_lastNameTextField ] &&
    [self isValidTextField:_emailField] &&
    [self isValidTextField:_usernameTextField ] &&
            [self isValidTextField:_passwordTextField ]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.firstNameTextField]) {
        [self.lastNameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.lastNameTextField]) {
        [self.emailField becomeFirstResponder];
    } else if ([textField isEqual:self.emailField]) {
        [self.usernameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.usernameTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
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
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                            [defaults setObject:[user objectForKey:@"currentClasses"] forKey:@"Classes"];
                                            [defaults synchronize];
                                            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                                            [appDelegate.window setRootViewController:appDelegate.tabBarController];
                                        } else {
                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"There was an error logging in." message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                             handler:^(UIAlertAction * action) {}];
                                            
                                            [alert addAction:okAction];
                                            [self presentViewController:alert animated:YES completion:nil];
                                        }
                                    }];
}

@end
