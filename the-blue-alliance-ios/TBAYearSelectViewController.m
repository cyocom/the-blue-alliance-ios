//
//  TBAYearSelectViewController.m
//  the-blue-alliance-ios
//
//  Created by Zach Orr on 3/27/15.
//  Copyright (c) 2015 The Blue Alliance. All rights reserved.
//

#import "TBAYearSelectViewController.h"
#import "TBASelectYearViewController.h"

@interface TBAYearSelectViewController ()

@property (nonatomic, strong) UIBarButtonItem *selectYearBarButtonItem;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *yearLabel;

@end

@implementation TBAYearSelectViewController

#pragma mark - Class Methods

+ (NSInteger)currentYear {
    // TODO: Look for year + 1 as well when data starts coming in
    return [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
}

+ (NSArray *)yearsBetweenStartYear:(NSInteger)startYear endYear:(NSInteger)endYear {
    NSMutableArray *years = [[NSMutableArray alloc] init];
    for (NSInteger i = endYear; i >= startYear; i--) {
        [years addObject:[NSNumber numberWithInteger:i]];
    }
    return years;
}

#pragma mark - Properities

- (NSUInteger)currentYear {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[self currentYearUserDefaultsString]];
}

- (void)setCurrentYear:(NSUInteger)currentYear {
    [[NSUserDefaults standardUserDefaults] setInteger:currentYear forKey:[self currentYearUserDefaultsString]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateYearInterface];
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupTapGesture];
    [self updateYearInterface];
}

#pragma mark - Interface Methods

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectYearButtonTapped:)];
    [self.navigationItem.titleView addGestureRecognizer:tapGesture];
}

- (void)updateYearInterface {
    self.titleLabel.text = self.navigationItem.title;
    if (self.currentYear == 0) {
        self.yearLabel.text = @"---";
    } else {
        self.yearLabel.text = [NSString stringWithFormat:@"▾ %zd", self.currentYear];
    }
}

- (void)selectYearButtonTapped:(id)sender {
    if (self.currentYear == 0) {
        return;
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    UINavigationController *navigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"TBASelectYearNavigationController"];
    TBASelectYearViewController *selectYearViewController = navigationController.viewControllers.firstObject;
    selectYearViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    selectYearViewController.currentYear = self.currentYear;
    selectYearViewController.years = self.years;
    if (self.yearSelected) {
        selectYearViewController.yearSelectedCallback = self.yearSelected;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:navigationController animated:YES completion:nil];
    }];
}

#pragma mark - Private Methods

- (NSString *)currentYearUserDefaultsString {
    NSString *classString = NSStringFromClass([self class]);
    return [NSString stringWithFormat:@"%@.currentYear", classString];
}

@end
