//
//  HomeScreenViewController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
//#import <GoogleMaps/GoogleMaps.h>

#import "SelectClassesViewController.h"
#import "SelectClassesTableViewCellUnselected.h"
#import "SelectClassesSelectedWithTextFieldTableViewCell.h"
#import "EnrolledClass.h"
#import "SetLocationStatusViewController.h"
#import "UpdateLocationStatusViewController.h"
#import "noModalNavigationController.h"
#import "FindNightOwlsViewController.h"

static NSString* const UnselectedClassCell = @"SelectClassesTableViewCellUnselected";
static NSString* const SelectedClassCell = @"SelectClassesSelectedWithTextFieldTableViewCell";
static NSUInteger const MaxStatusLength = 40;


@interface SelectClassesViewController () <UITableViewDataSource, UITableViewDelegate, SetLocationStatusViewControllerDelegate, noModalNavigationControllerDelegate, UpdateLocationStatusViewControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) id<SelectClassesViewControllerDelegate> delegate;
@property (nonatomic) NSArray *currentClasses;
@property (nonatomic) NSMutableDictionary *classInfo;
@property (nonatomic) NSUInteger activeClasses;
@property (nonatomic) NSString *location;
@end

@implementation SelectClassesViewController

#pragma mark Initialization Methods
- (id)initWithDelegate:(id<SelectClassesViewControllerDelegate>)delegate {
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]) {
        self.delegate = delegate;
        self.title = @"NightOwl";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:nil bundle:nil];
}

#pragma mark View Controller Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.location = @"";
    
    UINib *unselectedCellNib = [UINib nibWithNibName:UnselectedClassCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:unselectedCellNib forCellReuseIdentifier:UnselectedClassCell];
    UINib *selectedCellNib = [UINib nibWithNibName:UnselectedClassCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:selectedCellNib forCellReuseIdentifier:UnselectedClassCell];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 109.0, 0.0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.classInfo = [[NSMutableDictionary alloc] init];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = @"Select Classes";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentClasses = [defaults objectForKey:@"Classes"];
    for (id className in self.currentClasses) {
        if (![self.classInfo objectForKey:className]) {
            [self.classInfo setObject:[[EnrolledClass alloc] initWithClass:className] forKey:className];
        }
    }
    self.activeClasses = 0;
    for (id key in [self.classInfo allKeys]) {
        if (![self.currentClasses containsObject:key]) {
            [self.classInfo removeObjectForKey:key];
        } else if (((EnrolledClass *)[self.classInfo objectForKey:key]).active) {
            self.activeClasses++;
        }
    }
    
    self.buttonView.layer.cornerRadius = 8;
    
    [self setButtonColor];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    #pragma unused(tableView)
    if (section == 0) {
        return [self.currentClasses count];
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[SelectClassesSelectedWithTextFieldTableViewCell class]]) {
        NSString *key = [(SelectClassesSelectedWithTextFieldTableViewCell *)cell getName];
        [self findNightOwlsForClass:key];
//        UpdateLocationStatusViewController* ulsvc = [[UpdateLocationStatusViewController alloc] initWithDelegate:self classTitle:key currLocation:self.location currStatus:((EnrolledClass *)[self.classInfo objectForKey:key]).status];
//        noModalNavigationController *modal = [[noModalNavigationController alloc] initWithRootViewController:ulsvc withDelegate:self];
//        [self.navigationController presentViewController:modal animated:YES completion:nil];
    } else {
        NSString *key = [(SelectClassesTableViewCellUnselected *)cell getName];
        ((EnrolledClass *)[self.classInfo objectForKey:key]).active = YES;
        self.activeClasses++;
        [self.tableView reloadData];
        //        NSString *key = [(SelectClassesTableViewCellUnselected *)cell getName];
//        SetLocationStatusViewController* slsvc = [[SetLocationStatusViewController alloc] initWithDelegate:self classTitle:key currLocation:self.location];
//        noModalNavigationController *modal = [[noModalNavigationController alloc] initWithRootViewController:slsvc withDelegate:self];
//        [self.navigationController presentViewController:modal animated:YES completion:nil];
    }
    [self setButtonColor];
    [tableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView
       cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *classTitle = [self.currentClasses objectAtIndex:(NSUInteger)indexPath.row];
    EnrolledClass *classObj = (EnrolledClass *)[self.classInfo objectForKey:classTitle];
    if (classObj.active) {
        SelectClassesSelectedWithTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectedClassCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:SelectedClassCell owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.statusLabel.delegate = self;
        cell.activeButton.tag = indexPath.row;
        [cell.activeButton addTarget:self action:@selector(deactivateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell configureCell:classTitle withStatus:classObj.status];
        return cell;
    } else {
        SelectClassesTableViewCellUnselected *cell = [tableView dequeueReusableCellWithIdentifier:UnselectedClassCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:UnselectedClassCell owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell configureCell:classTitle];
        return cell;
    }
}

#pragma mark Private Methods
- (void)setButtonColor {
    if (self.activeClasses > 0) {
        self.buttonView.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
        self.buttonView.layer.masksToBounds = NO;
        self.buttonView.layer.shadowOffset = CGSizeMake(5, 5);
        self.buttonView.layer.shadowRadius = 5;
        self.buttonView.layer.shadowOpacity = 0.5;
        self.button.enabled = YES;
    } else {
        self.buttonView.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
        self.buttonView.layer.masksToBounds = YES;
        self.buttonView.layer.shadowOffset = CGSizeMake(0, 0);
        self.button.enabled = NO;
    }
}

- (void)alertSelectedOkForClass:(NSString *)className {
    ((EnrolledClass *)[self.classInfo objectForKey:className]).active = NO;
    self.activeClasses--;
    if (self.activeClasses == 0) {
        self.location = @"";
    }
    [self setButtonColor];
    [self.tableView reloadData];
}

-(void)deactivateButtonClicked:(UIButton*)sender
{
    NSString *key = [self.currentClasses objectAtIndex:sender.tag];
    NSString *actionTitle = [NSString stringWithFormat:@"Deactivate for %@?", key];
    NSString *actionMessage = [NSString stringWithFormat:@"Are you sure you are done working on %@?", key];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:actionTitle message:actionMessage preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self alertSelectedOkForClass:key];
                                                     }];
    
    [alert addAction:yesAction];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)findNightOwlsForClass:(NSString *)class {
    NSMutableArray *activeClasses = [[NSMutableArray alloc] initWithCapacity:self.activeClasses];
    for (id key in [self.classInfo allKeys]) {
        if (((EnrolledClass *)[self.classInfo objectForKey:key]).active) {
            [activeClasses addObject:key];
        }
    }
    [activeClasses sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    FindNightOwlsViewController *fnovc = [[FindNightOwlsViewController alloc] initWithClassList:activeClasses highlightedClassIndex:[activeClasses indexOfObject:class]];
    [self.navigationController pushViewController:fnovc animated:YES];
}

#pragma mark TextViewDleegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    if([string isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return [self isAcceptableTextLength:textView.text.length + string.length - range.length];
}

- (BOOL)isAcceptableTextLength:(NSUInteger)length {
    return length <= MaxStatusLength;
}

#pragma mark SetLocationStatusViewControllerDelegate methods
- (void)setLocationStatusViewController:(SetLocationStatusViewController *)selectClassesViewController
                       didActivateClass:(NSString *)selectedClass
                           withLocation:(NSString *)location
                              andStatus:(NSString *)status {
    self.location = location;
    EnrolledClass *classObj = (EnrolledClass *)[self.classInfo objectForKey:selectedClass];
    classObj.status = status;
    classObj.active = YES;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UpdateLocationStatusViewControllerDelegate methods
- (void)updateLocationStatusViewController:(UpdateLocationStatusViewController *)selectClassesViewController
                            didUpdateClass:(NSString *)selectedClass
                              withLocation:(NSString *)location
                                 andStatus:(NSString *)status {
    self.location = location;
    EnrolledClass *classObj = (EnrolledClass *)[self.classInfo objectForKey:selectedClass];
    classObj.status = status;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateLocationStatusViewController:(UpdateLocationStatusViewController *)selectClassesViewController
                        didDeactivateClass:(NSString *)selectedClass {
    ((EnrolledClass *)[self.classInfo objectForKey:selectedClass]).active = NO;
    self.activeClasses--;
    if (self.activeClasses == 0) {
        self.location = @"";
    }
    [self setButtonColor];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark noModalNavigationControllerDelegate Methods
- (void)didDismissNoModalNavigationController:(noModalNavigationController *)noModalNavigationController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
