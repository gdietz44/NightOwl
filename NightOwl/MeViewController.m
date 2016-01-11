//
//  MeViewController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "MeViewController.h"
#import "AddAClassTableViewCell.h"

static NSString* const AddAClassCell = @"AddAClassTableViewCell";

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
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

    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
}


- (void)viewWillAppear:(BOOL)animated {
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
