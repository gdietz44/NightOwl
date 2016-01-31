//
//  FindNightOwlsViewController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/24/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "FindNightOwlsViewController.h"
#import "FindNightOwlTableViewCell.h"
#import "HorizontalPickerView.h"
#import "HardcodedUserData.h"
#import "User.h"
#import "SendAMessageViewController.h"
#import "noModalNavigationController.h"
#import "Message.h"

@import CoreLocation;

static NSString* const FindNightOwlCell = @"FindNightOwlTableViewCell";

@interface FindNightOwlsViewController ()<HorizontalPickerViewDataSource,HorizontalPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, SendAMessageViewControllerDelegate, noModalNavigationControllerDelegate> {
    BOOL firstAppearance;
    NSUInteger startIndex;
}
@property (weak, nonatomic) IBOutlet HorizontalPickerView *horizontalPicker;
@property (nonatomic) NSArray *classes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) HardcodedUserData *userData;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic) NSArray *visibleUsers;
@property (nonatomic) NSUInteger withinHalfAMile;
@property (nonatomic) NSUInteger withinAQuarterMile;
@property (nonatomic) NSUInteger withinAMile;
@end

@implementation FindNightOwlsViewController
#pragma mark Initialization
- (id)initWithClassList:(NSArray *)activeClasses highlightedClassIndex:(NSUInteger)index {
    if (self = [super init]) {
        self.classes = activeClasses;
        startIndex = index;
    }
    return self;
}

#pragma mark ViewController Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Find NightOwls";
    
    firstAppearance = YES;
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.location = CLLocationCoordinate2DMake(37.426407, -122.171911);
    
    self.horizontalPicker.dataSource = self;
    self.horizontalPicker.delegate = self;
    self.horizontalPicker.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    self.horizontalPicker.textColor = [UIColor colorWithRed:163.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0];
    self.horizontalPicker.highlightedTextColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
    self.horizontalPicker.highlightedFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    self.horizontalPicker.pickerViewStyle = HorizontalPickerViewStyleFlat;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *cellNib = [UINib nibWithNibName:FindNightOwlCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:FindNightOwlCell];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 49.0, 0.0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(decreasePicker)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(increasePicker)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeRight];
    
    self.userData = [[HardcodedUserData alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (firstAppearance) {
        [self.horizontalPicker selectItem:startIndex animated:NO];
        firstAppearance = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark HorizontalPickerViewDelegate Methods
- (NSUInteger)numberOfItemsInPickerView:(HorizontalPickerView *)pickerView {
    return [self.classes count];
}

- (CGSize)pickerView:(HorizontalPickerView *)pickerView
       marginForItem:(NSInteger)item {
    return CGSizeMake(20, 10);
}


- (NSString *)pickerView:(HorizontalPickerView *)pickerView
            titleForItem:(NSInteger)item {
    NSString *string = [NSString stringWithFormat:@"%@",[self.classes objectAtIndex:item]];
    return string;
}

- (void)pickerView:(HorizontalPickerView *)pickerView
     didSelectItem:(NSInteger)item {
    NSArray *unsortedArr = [self.userData.users filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(User* userObject, NSDictionary *bindings) {
        return [userObject.sharedClasses containsObject:[NSString stringWithFormat:@"%@",[self.classes objectAtIndex:item]]];
    }]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.visibleUsers = [unsortedArr sortedArrayUsingDescriptors:sortDescriptors];
    self.withinHalfAMile = 0;
    self.withinAMile = 0;
    self.withinAQuarterMile = 0;
    for (User *user in self.visibleUsers) {
        if(user.distance < 402) {
            self.withinAQuarterMile++;
        } else if(user.distance < 865) {
            self.withinHalfAMile++;
        } else if (user.distance < 1609) {
            self.withinAMile++;
        }
    }
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

#pragma mark TableViewDelegate/DataSource Methods
- (CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 73.5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 0;
    if (self.withinAQuarterMile > 0) sections++;
    if (self.withinHalfAMile > 0) sections++;
    if (self.withinAMile > 0) sections++;
    if ([self.visibleUsers count] - self.withinAMile - self.withinHalfAMile - self.withinAQuarterMile > 0) sections++;
    return sections;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if (self.withinAQuarterMile > 0) {
        if (section == 0) {
            return @"Within 1/4 Mile";
        } else if (section == 1) {
            return @"Within 1/2 Mile";
        } else if (section == 2) {
            return @"Within 1 Mile";
        } else {
            return @"Within 5 Miles";
        }
    } else {
        if (section == 0) {
            return @"Within 1/2 Mile";
        } else if (section == 1) {
            return @"Within 1 Mile";
        } else {
            return @"Within 5 Miles";
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(8, 4, 320, 20);
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textColor = [UIColor darkGrayColor];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:label];
    headerView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1];
    
    return headerView;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    if (self.withinAQuarterMile > 0) {
        if (section == 0) {
            return self.withinAQuarterMile;
        } else if (section == 1) {
            return self.withinHalfAMile;
        } else if (section == 2) {
            return self.withinAMile;
        } else {
            return [self.visibleUsers count] - self.withinAMile - self.withinHalfAMile - self.withinAQuarterMile;
        }
    } else {
        if (section == 0) {
            return self.withinHalfAMile;
        } else if (section == 1) {
            return self.withinAMile;
        } else {
            return [self.visibleUsers count] - self.withinAMile - self.withinHalfAMile - self.withinAQuarterMile;
            
        }
    }
}

-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindNightOwlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FindNightOwlCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:FindNightOwlCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSInteger index = indexPath.row;
    for (int i = 0; i < indexPath.section; i++) {
        index += [tableView numberOfRowsInSection:i];
    }
    User *user = [self.visibleUsers objectAtIndex:index];
    NSString *title = [NSString stringWithFormat:@"%@ @ %@",user.name,user.locationName];
    [cell configureCellWithTitle:title status:user.status image:user.image];
    [cell setNeedsUpdateConstraints];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    if (indexPath.section == 1) {
        index += self.withinAQuarterMile;
    } else if (indexPath.section == 2) {
        index += self.withinAQuarterMile + self.withinHalfAMile;
    } else if (indexPath.section == 3) {
        index += self.withinAMile + self.withinHalfAMile + self.withinAQuarterMile;
    }
    User *user = [self.visibleUsers objectAtIndex:index];
    SendAMessageViewController *samvc = [[SendAMessageViewController alloc] initWithDelegate:self userToContact:user];
    noModalNavigationController *modal = [[noModalNavigationController alloc] initWithRootViewController:samvc withDelegate:self];
    [self.navigationController presentViewController:modal animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark noModalNavigationControllerDelegate Methods
- (void)didDismissNoModalNavigationController:(noModalNavigationController *)noModalNavigationController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark SendAMessageViewControllerDelegate Methods
- (void)sendAMessageViewController:(SendAMessageViewController *)samvc
                    didContactUser:(User *)user
                       withMessage:(NSString *)messageText {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    Message *message = [[Message alloc] initWithUser:user message:messageText];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Conversation Began" object:message];
}

#pragma mark Private Methods
- (void)increasePicker {
    NSInteger index = [self.horizontalPicker selectedItem];
    if (index != 0) {
        [self.horizontalPicker selectItem:index - 1 animated:YES];
    }
}

- (void)decreasePicker {
    NSInteger index = [self.horizontalPicker selectedItem];
    if (index != (self.classes.count - 1)) {
        [self.horizontalPicker selectItem:index + 1 animated:YES];
    }
}

@end
