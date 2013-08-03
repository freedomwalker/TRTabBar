//
//  TRTabBarView.h
//  TRTabs
//
//  Created by liuyu on 8/3/13.
//  Copyright (c) 2013 tapray.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TRTabBarViewDelegate;

@interface TRTabBarView : UIView
{
	__unsafe_unretained id<TRTabBarViewDelegate> _delegate;
}

@property (nonatomic, readonly) NSArray *mTabTitles;
@property (nonatomic, readonly) NSInteger mSelectedItemIndex;

@property (nonatomic, unsafe_unretained) id<TRTabBarViewDelegate> delegate;

/**
 
 This method create and return a TRTabBarView object
 
 @param  frame frame for the TRTabBarView
 @param  tabTitles titles info for tabs
 @param  selectedImage background image for the selected tab
 @param  norTextColor text color for the tab not selected
 @param  selTextColor text color for the tab selected

 @return a TRTabBarView object
 
 */

- (id)initWithFrame:(CGRect)frame tabTitles:(NSArray *)tabTitles selectedImage:(UIImage *)selectedImage norTextClor:(UIColor *)norTextColor selTextClor:(UIColor *)selTextColor;

/**
 
 This method set background image for the tabBar view
 
 @param image background image for the tabBar view
 
 */

- (void)setBackgroundImage:(UIImage *)image;

/**
 
 This method set tab with the given index selected
 
 @param index tab to be selected
 
 */

- (void)selectTabBarAtIndex:(NSInteger)index;

@end

@protocol TRTabBarViewDelegate<NSObject>

@optional

- (void)tabBarView:(TRTabBarView *)tabBarView didSelectIndex:(NSInteger)index;

@end
