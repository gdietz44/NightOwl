//
//  HorizontalPickerView.h
//  HorizontalPickerViewSample
//
//  Created by Akio Yasui on 3/29/14.
//  Copyright (c) 2014 Akio Yasui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HorizontalPickerViewStyle) {
    HorizontalPickerViewStyle3D = 1,
    HorizontalPickerViewStyleFlat
};

@class HorizontalPickerView;

@protocol HorizontalPickerViewDataSource <NSObject>
@required
- (NSUInteger)numberOfItemsInPickerView:(HorizontalPickerView *)pickerView;
@optional
- (NSString *)pickerView:(HorizontalPickerView *)pickerView titleForItem:(NSInteger)item;
- (UIImage *)pickerView:(HorizontalPickerView *)pickerView imageForItem:(NSInteger)item;
@end

@protocol HorizontalPickerViewDelegate <UIScrollViewDelegate>
@optional
- (void)pickerView:(HorizontalPickerView *)pickerView didSelectItem:(NSInteger)item;
- (CGSize)pickerView:(HorizontalPickerView *)pickerView marginForItem:(NSInteger)item;
- (void)pickerView:(HorizontalPickerView *)pickerView configureLabel:(UILabel * const)label forItem:(NSInteger)item;
@end

@interface HorizontalPickerView : UIView

@property (nonatomic, weak) id <HorizontalPickerViewDataSource> dataSource;
@property (nonatomic, weak) id <HorizontalPickerViewDelegate> delegate;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *highlightedFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightedTextColor;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, assign) CGFloat fisheyeFactor; // 0...1; slight value recommended such as 0.0001
@property (nonatomic, assign, getter=isMaskDisabled) BOOL maskDisabled;
@property (nonatomic, assign) HorizontalPickerViewStyle pickerViewStyle;
@property (nonatomic, assign, readonly) NSUInteger selectedItem;
@property (nonatomic, assign, readonly) CGPoint contentOffset;

- (void)reloadData;
- (void)scrollToItem:(NSUInteger)item animated:(BOOL)animated;
- (void)selectItem:(NSUInteger)item animated:(BOOL)animated;

@end