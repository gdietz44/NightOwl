//
//  HomeScreenViewController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

#import "SelectClassesViewController.h"
#import "SelectClassesTableViewCellUnselected.h"
#import "SelectClassesSelectedWithTextFieldTableViewCell.h"
#import "EnrolledClass.h"
#import "SetLocationStatusViewController.h"
#import "UpdateLocationStatusViewController.h"
#import "noModalNavigationController.h"
#import "FindNightOwlsViewController.h"
#import "GMSPlacesClient.h"

static NSString* const UnselectedClassCell = @"SelectClassesTableViewCellUnselected";
static NSString* const SelectedClassCell = @"SelectClassesSelectedWithTextFieldTableViewCell";
static NSUInteger const MaxStatusLength = 40;


@interface SelectClassesViewController () <UITableViewDataSource, UITableViewDelegate, SetLocationStatusViewControllerDelegate, noModalNavigationControllerDelegate, UpdateLocationStatusViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<SelectClassesViewControllerDelegate> delegate;
@property (nonatomic) NSArray *currentClasses;
@property (nonatomic) NSMutableArray *activeClassesArr;
@property (nonatomic) NSMutableDictionary *classInfo;
@property (nonatomic) NSUInteger activeClasses;
@property (nonatomic) NSString *location;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (nonatomic) PFUser *currentUser;
@property (nonatomic) NSMutableArray* statuses;
@property (nonatomic) CLLocationManager *lm;
@property (nonatomic) NSInteger editCellIndex;
@property (nonatomic) CLLocationCoordinate2D coord;
@end

@implementation SelectClassesViewController {
    GMSPlacesClient *_placesClient;
}

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
    _placesClient = [[GMSPlacesClient alloc] init];
    
    self.location = @"";
    self.currentUser = [PFUser currentUser];
    
    UINib *unselectedCellNib = [UINib nibWithNibName:UnselectedClassCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:unselectedCellNib forCellReuseIdentifier:UnselectedClassCell];
    UINib *selectedCellNib = [UINib nibWithNibName:UnselectedClassCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:selectedCellNib forCellReuseIdentifier:UnselectedClassCell];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 109.0, 0.0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.classInfo = [[NSMutableDictionary alloc] init];
    self.activeClassesArr = [[NSMutableArray alloc] init];
    self.statuses = [[NSMutableArray alloc] init];
    self.editCellIndex = -1;
    self.locationField.delegate = self;
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
    [super viewWillAppear:animated];
    
    
    self.lm = [[CLLocationManager alloc] init];
    [self.lm requestWhenInUseAuthorization];
    self.lm.delegate = self;
    self.lm.desiredAccuracy = kCLLocationAccuracyBest;
    self.lm.distanceFilter = kCLDistanceFilterNone;
    [self.lm startMonitoringSignificantLocationChanges];
    [self.lm startUpdatingLocation];

    self.navigationController.navigationBar.topItem.title = @"NightOwl";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentClasses = [defaults objectForKey:@"Classes"];
    self.currentUser[@"currentClasses"] = self.currentClasses;
    for (id className in self.currentClasses) {
        if (![self.classInfo objectForKey:className]) {
            [self.classInfo setObject:[[EnrolledClass alloc] initWithClass:className] forKey:className];
        }
    }
   
    self.activeClasses = 0;
    [self.activeClassesArr removeAllObjects];
    [self.statuses removeAllObjects];
    for (id key in [self.classInfo allKeys]) {
        if (![self.currentClasses containsObject:key]) {
            [self.classInfo removeObjectForKey:key];
        } else if (((EnrolledClass *)[self.classInfo objectForKey:key]).active) {
            [self.activeClassesArr addObject:key];
            [self.statuses addObject:((EnrolledClass *)[self.classInfo objectForKey:key]).status];
            self.activeClasses++;
        }
    }
    self.currentUser[@"activeClasses"] = self.activeClassesArr;
    self.currentUser[@"statuses"] = self.statuses;
    [self.currentUser saveInBackground];
    
    if (self.currentClasses.count == 0) {
        UILabel *backgroundView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.tableView.bounds.size.width,self.tableView.bounds.size.height)];
        backgroundView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
        backgroundView.text = @"Go to Me tab to add your classes.";
        backgroundView.textColor = [UIColor colorWithRed:165.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1];
        backgroundView.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = backgroundView;
    } else {
        self.tableView.backgroundView = nil;
    }
    
    self.locationField.text = self.location;
    
//    self.buttonView.layer.cornerRadius = 8;
//    [self setButtonColor];
    
    [self reloadTable];
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
        if([self.location isEqual:@""]) {
            [self showLocationRequiredAlert];
        } else {
            NSString *key = [(SelectClassesSelectedWithTextFieldTableViewCell *)cell getName];
            [self findNightOwlsForClass:key];
        }
    } else {
        NSString *key = [(SelectClassesTableViewCellUnselected *)cell getName];
        ((EnrolledClass *)[self.classInfo objectForKey:key]).active = YES;
        self.activeClasses++;
        self.editCellIndex = indexPath.row;
    }
    [self reloadTable];
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
        [cell configureCell:classTitle withStatus:classObj.status withIndex:indexPath.row];
        if(self.editCellIndex == indexPath.row) {
            [cell.statusLabel becomeFirstResponder];
        }
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

#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.coord = [[locations lastObject] coordinate];
    self.currentUser[@"latitude"] = [NSNumber numberWithDouble:self.coord.latitude];
    self.currentUser[@"longitude"] = [NSNumber numberWithDouble:self.coord.longitude];
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
            NSLog(@"Current Place error %@", [error localizedDescription]);
            [self.currentUser saveInBackground];
            return;
        }
        
        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
            GMSPlace* place = likelihood.place;
            if([place.types containsObject:@"establishment"] && ![place.name  isEqual: @"Stanford University"]) {
                self.location = place.name;
                self.locationField.text = place.name;
                self.currentUser[@"locationName"] = place.name;
                [self.currentUser saveInBackground];
                break;
            }
        }
        
    }];
}


#pragma mark Private Methods
- (void)reloadTable {
    [self.tableView reloadData];
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.editCellIndex inSection:0];
    SelectClassesSelectedWithTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    [cell.statusLabel becomeFirstResponder];
}

- (void)alertSelectedOkForClass:(NSString *)className {
    ((EnrolledClass *)[self.classInfo objectForKey:className]).active = NO;
    ((EnrolledClass *)[self.classInfo objectForKey:className]).status = @"";
    self.activeClasses--;
    [self.statuses removeObjectAtIndex:[self.activeClassesArr indexOfObject:className]];
    [self.activeClassesArr removeObject:className];
    self.currentUser[@"activeClasses"] = self.activeClassesArr;
    self.currentUser[@"statuses"] = self.statuses;
    [self.currentUser saveInBackground];
    [self reloadTable];
}

-(void)deactivateButtonClicked:(UIButton*)sender
{
    NSString *key = [self.currentClasses objectAtIndex:sender.tag];
    NSString *actionTitle = [NSString stringWithFormat:@"Done working on %@?", key];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:actionTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self alertSelectedOkForClass:key];
                                                     }];
    
    [alert addAction:yesAction];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    
    [alert addAction:noAction];
    [alert.view setTintColor:[UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showLocationRequiredAlert {
    NSString *actionTitle = [NSString stringWithFormat:@"A location is required."];
    NSString *actionMessage = [NSString stringWithFormat:@"Please enter your current location in the location field."];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:actionTitle message:actionMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {}];
    
    [alert addAction:okAction];
    [alert.view setTintColor:[UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1]];
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
    FindNightOwlsViewController *fnovc = [[FindNightOwlsViewController alloc] initWithClassList:activeClasses highlightedClassIndex:[activeClasses indexOfObject:class] currentLocation:self.coord];
    [self.navigationController pushViewController:fnovc animated:YES];
}

#pragma mark TextFieldDelegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.location = self.locationField.text;
    self.currentUser[@"locationName"] = self.location;
    [self.currentUser saveInBackground];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark TextViewDelegate Methods
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSUInteger tag = textView.tag;
    self.editCellIndex = -1;
    NSString *className = [self.currentClasses objectAtIndex:tag];
    if ([textView.text isEqual:@""]) {
        ((EnrolledClass *)[self.classInfo objectForKey:className]).active = NO;
        self.activeClasses--;
        [self reloadTable];
    } else {
        ((EnrolledClass *)[self.classInfo objectForKey:className]).status = textView.text;
        if([self.activeClassesArr containsObject:className]) {
            [self.statuses replaceObjectAtIndex:[self.activeClassesArr indexOfObject:className] withObject:textView.text];
            self.currentUser[@"statuses"] = self.statuses;
        } else {
            [self.activeClassesArr addObject:className];
            [self.statuses addObject:textView.text];
            
            self.currentUser[@"activeClasses"] = self.activeClassesArr;
            self.currentUser[@"statuses"] = self.statuses;
        }
        [self.currentUser saveInBackground];
        [self reloadTable];
    }
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)string {
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
    ((EnrolledClass *)[self.classInfo objectForKey:selectedClass]).status = @"";
    self.activeClasses--;
//    [self setButtonColor];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark noModalNavigationControllerDelegate Methods
- (void)didDismissNoModalNavigationController:(noModalNavigationController *)noModalNavigationController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
