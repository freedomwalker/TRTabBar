//
//  TRViewController.m
//  TRTabs
//
//  Created by liuyu on 8/3/13.
//  Copyright (c) 2013 tapray.com. All rights reserved.
//

#import "TRViewController.h"
#import "TRTabBarView.h"

@interface TRViewController ()

@property (nonatomic, retain) NSArray *mTabTitles;
@property (nonatomic, retain) UIScrollView *mScrollView;

@end

@implementation TRViewController {
    
    TRTabBarView *_mTabBarView;
    NSMutableDictionary *_mViewsDic;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupTabBarView
{
    UIColor *norColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1.0];
    UIColor *selColor = [UIColor blackColor];
    UIColor *backgroundColor = [UIColor clearColor];
    NSString *imageName = @"tr_item_sel.png";
    NSString *tabBackgroundImageName = @"tr_tab_bg.png";
    
    _mTabBarView = [[TRTabBarView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 39.0) tabTitles:self.mTabTitles selectedImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0 topCapHeight:0] norTextClor:norColor selTextClor:selColor];
    _mTabBarView.backgroundColor = backgroundColor;
    [_mTabBarView setBackgroundImage:[UIImage imageNamed:tabBackgroundImageName]];
    _mTabBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mTabBarView.delegate = (id<TRTabBarViewDelegate>)self;
    
    [self.view addSubview:_mTabBarView];
}

- (void)setupScrollView
{
    CGFloat topMargin = _mTabBarView.frame.origin.y + _mTabBarView.frame.size.height;
    
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topMargin, self.view.bounds.size.width, self.view.bounds.size.height - topMargin)];
    _mScrollView.pagingEnabled = YES;
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = NO;
    _mScrollView.scrollsToTop = NO;
    _mScrollView.delegate = (id<UIScrollViewDelegate>)self;
    _mScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mScrollView];
    
    _mScrollView.contentSize = CGSizeMake([_mTabBarView.mTabTitles count] * self.view.bounds.size.width, self.view.bounds.size.height - topMargin);
}

- (void)setupContentViewWithTag:(NSInteger)tag
{
    NSString *key = [NSString stringWithFormat:@"%d", tag];
    if ([_mViewsDic objectForKey:key])
    {
        return;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tag * _mScrollView.bounds.size.width + 4, 4, _mScrollView.bounds.size.width - 8, _mScrollView.bounds.size.height - 8)];
    label.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.5];
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    label.font = [UIFont boldSystemFontOfSize:80.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = key;
    
    [_mViewsDic setObject:label forKey:key];
    [_mScrollView addSubview:label];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    self.title = @"TRTabBar";
    
    _mViewsDic = [[NSMutableDictionary alloc] init];
    
    self.mTabTitles = @[@{@"title": @"头条"}, @{@"title": @"移动互联网"}, @{@"title": @"科技"}, @{@"title": @"娱乐"}, @{@"title": @"财经"}, @{@"title": @"教育"}];
    
    [self setupTabBarView]; // tab bars
    [self setupScrollView];
    [self setupContentViewWithTag:0]; // setup 1th content view
}

#pragma mark UMUFPTabBarView Delegate

- (void)tabBarView:(TRTabBarView *)tabBarView didSelectIndex:(NSInteger)index
{
    [self setupContentViewWithTag:index];
    [self showPageForTabAtIndex:index];
}

- (void)showPageForTabAtIndex:(NSInteger)index
{
    
    [_mScrollView scrollRectToVisible:CGRectMake(index * _mScrollView.bounds.size.width, 0, _mScrollView.bounds.size.width, _mScrollView.bounds.size.height) animated:NO];
}

#pragma mark UIScrollView Delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    CGFloat pageWidth = self.mScrollView.frame.size.width;
    int page = floor((_mScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page < 0 || page >= [_mTabBarView.mTabTitles count])
    {
        return;
    }
    
    if (page != _mTabBarView.mSelectedItemIndex)
    {
        [_mTabBarView selectTabBarAtIndex:page];
        [self setupContentViewWithTag:page];
    }
}

// iOS >= 6.0

- (BOOL) shouldAutorotate {
    
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

// iOS < 6.0

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
