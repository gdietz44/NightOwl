//
//  MeViewController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "MeViewController.h"
#import "AddAClassTableViewCell.h"
#import <Parse/Parse.h>

static NSString* const AddAClassCell = @"AddAClassTableViewCell";

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UIImageView *textImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *profilePictureButton;
@property (nonatomic) PFUser *currentUser;
@property (nonatomic) UIImage *profileImage;
@property (weak, nonatomic) id<MeViewControllerDelegate> delegate;
@property (nonatomic) NSArray *currentClasses;
@property (nonatomic) NSMutableArray *cellsSelectedToDelete;
@end

@implementation MeViewController

- (id)initWithDelegate:(id<MeViewControllerDelegate>)delegate {
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]) {
        self.delegate = delegate;
        self.title = @"My Profile";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"More-Gray"] style:UIBarButtonItemStyleDone target:self action:nil]; //add Action
    self.navigationItem.rightBarButtonItem = button;
    
    UINib *cellNib = [UINib nibWithNibName:AddAClassCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:AddAClassCell];
    self.deleteButton.hidden = YES;
    self.cancelButton.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.allowsSelection = NO;
    self.tableView.tintColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 49.0, 0.0);

    self.profilePictureButton.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profilePictureButton.layer.masksToBounds = YES;
    self.profilePictureButton.layer.borderWidth = 0;
    
    self.textImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.textImageView.layer.masksToBounds = YES;
    self.textImageView.layer.borderWidth = 0;
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    
    PFFile *file = [self.currentUser objectForKey:@"profilePicture"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error) {
            self.profileImage = [UIImage imageWithData:data];
            self.profileImageView.image = self.profileImage;
            self.textImageView.hidden = YES;
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    NSString *firstName = [self.currentUser objectForKey:@"firstName"];
    NSString *lastInitial = [[self.currentUser objectForKey:@"lastName"] substringToIndex:1];
    NSString *name = [NSString stringWithFormat:@"%@ %@.", firstName, lastInitial];
    self.nameField.text = name;
    
    if (self.profileImage == nil) {
        NSString *initials = [NSString stringWithFormat:@"%@%@", [firstName substringToIndex:1], lastInitial];
        CGSize size  = self.textImageView.frame.size;
        
        UIGraphicsBeginImageContext(size);
        
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0].CGColor);
        CGContextFillRect(UIGraphicsGetCurrentContext(), self.textImageView.bounds);
        
        CGSize textSize = [initials sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:48], NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        [initials drawAtPoint:CGPointMake((self.textImageView.bounds.size.width / 2) - (textSize.width / 2), (self.textImageView.bounds.size.height / 2) - (textSize.height / 2)) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:48], NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        // transfer image
        CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
        
        UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.textImageView.image = textImage;
        self.textImageView.contentMode = UIViewContentModeCenter;
    } else {
        self.profileImageView.image = self.profileImage;
        self.textImageView.hidden = YES;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentClasses = [defaults objectForKey:@"Classes"];
    [self updateButtonsToMatchTableState];
    [self updateDeleteButtonTitle];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateDeleteButtonTitle];
}

- (void)tableView:(UITableView *)tableView
didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateDeleteButtonTitle];
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    return [self.currentClasses count];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.currentClasses];
        [tempArr removeObjectAtIndex:indexPath.row];
        self.currentClasses = tempArr;
        [self.currentUser setObject:self.currentClasses forKey:@"currentClasses"];
        [self.currentUser saveInBackground];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.currentClasses forKey:@"Classes"];
        [defaults synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddAClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddAClassCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:AddAClassCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString *class = [self.currentClasses objectAtIndex:(NSUInteger)indexPath.row];
    [(AddAClassTableViewCell *)cell configureCellWithClassName:class];
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return cell;
}

#pragma mark Profile Image
- (IBAction)addImage:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a New Profile Picture" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* existingAction = [UIAlertAction actionWithTitle:@"Choose Existing Photo" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self chooseExistingPhoto];
                                                     }];
    
    [alert addAction:existingAction];
    UIAlertAction* takeAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self takePhoto];
                                                         }];
    
    [alert addAction:takeAction];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    
    [alert addAction:cancelAction];
    
    [alert.view setTintColor:[UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ActionSheet delegates

- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pickerView =[[UIImagePickerController alloc] init];
        
        pickerView.navigationBar.barTintColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
        pickerView.navigationBar.tintColor = [UIColor whiteColor];
        [pickerView.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        pickerView.navigationBar.translucent = NO;
        pickerView.navigationBar.barStyle = UIBarStyleBlack;
        
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerView.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:pickerView animated:YES completion:nil];
    }
}

- (void) chooseExistingPhoto {
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    
    pickerView.navigationBar.barTintColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
    pickerView.navigationBar.tintColor = [UIColor whiteColor];
    [pickerView.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    pickerView.navigationBar.translucent = NO;
    pickerView.navigationBar.barStyle = UIBarStyleBlack;
    
    pickerView.allowsEditing = YES;
    pickerView.delegate = self;
    [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerView animated:YES completion:nil];
}

#pragma mark - PickerDelegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];;
    
    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];
    self.textImageView.hidden = YES;
    self.profileImageView.image = image;
    
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    
    [self.currentUser setObject:imageFile forKey:@"profilePicture"];
    [self.currentUser saveInBackground];
    
}

#pragma mark Actions
- (IBAction)addClassButtonSelected:(id)sender {
    [self.delegate meViewControllerDidSelectAddClassButton:self];
}

- (IBAction)editClicked:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [self updateDeleteButtonTitle];
    [self updateButtonsToMatchTableState];
}

- (IBAction)cancelAction:(id)sender
{
    [self.tableView setEditing:NO animated:YES];
    [self updateButtonsToMatchTableState];
}

- (void)alertSelectedOk {
    // Delete what the user selected.
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    BOOL deleteSpecificRows = selectedRows.count > 0;
    if (deleteSpecificRows)
    {
        // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
        NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
        for (NSIndexPath *selectionIndex in selectedRows)
        {
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
        }
        // Delete the objects from our data model.
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.currentClasses];
        [tempArr removeObjectsAtIndexes:indicesOfItemsToDelete];
        self.currentClasses = tempArr;
        [self.currentUser setObject:self.currentClasses forKey:@"currentClasses"];
        [self.currentUser saveInBackground];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.currentClasses forKey:@"Classes"];
        [defaults synchronize];
        
        // Tell the tableView that we deleted the objects
        [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    } else { //no rows selected = deleate all rows
        // Delete everything, delete the objects from our data model.
        self.currentClasses = [[NSArray alloc] init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.currentClasses forKey:@"Classes"];
        
        // Tell the tableView that we deleted the objects.
        // Because we are deleting all the rows, just reload the current table section
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    // Exit editing mode after the deletion.
    [self.tableView setEditing:NO animated:YES];
    [self.tableView reloadData];
    [self updateButtonsToMatchTableState];
        
}

- (IBAction)deleteAction:(id)sender
{
    // Open a dialog with just an OK button.
    NSString *actionTitle;
    if (([[self.tableView indexPathsForSelectedRows] count] == 1)) {
        actionTitle = NSLocalizedString(@"Are you sure you want to remove this item?", @"");
    }
    else
    {
        actionTitle = NSLocalizedString(@"Are you sure you want to remove these items?", @"");
    }
    
    NSString *cancelTitle = NSLocalizedString(@"Cancel", @"Cancel title for item removal action");
    NSString *okTitle = NSLocalizedString(@"OK", @"OK title for item removal action");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:actionTitle message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self alertSelectedOk];
                                                          }];
    
    [alert addAction:okAction];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {}];
    
    [alert addAction:cancelAction];
    [alert.view setTintColor:[UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Updating button state

- (void)updateButtonsToMatchTableState
{
    if (self.tableView.editing) {
        self.editButton.hidden = YES;
        self.deleteButton.hidden = NO;
        self.cancelButton.hidden = NO;
        self.addButton.hidden = YES;
        self.tableView.allowsSelection = YES;
    } else {
        if([self.currentClasses count] > 0) {
            self.editButton.hidden = NO;
        } else {
            self.editButton.hidden = YES;
        }
        self.deleteButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.addButton.hidden = NO;
        self.tableView.allowsSelection = NO;
    }
}

- (void)updateDeleteButtonTitle {
    // Update the delete button's title, based on how many items are selected
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = (selectedRows.count == self.currentClasses.count);
    BOOL noItemsAreSelected = (selectedRows.count == 0);
    
    if (allItemsAreSelected || noItemsAreSelected)
    {
        [self.deleteButton setTitle:@"Delete All" forState:UIControlStateNormal];
    } else {
        NSString *titleFormatString =
        NSLocalizedString(@"Delete (%d)", @"Title for delete button with placeholder for number");
        [self.deleteButton setTitle:[NSString stringWithFormat:titleFormatString, selectedRows.count] forState:UIControlStateNormal];
    }
}




@end
