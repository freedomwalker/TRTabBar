//
//  TRTabBarView.h
//  TRTabs
//
//  Created by liuyu on 8/3/13.
//  Copyright (c) 2013 tapray.com. All rights reserved.
//

#import "TRTabBarView.h"

#define TOP_MARGIN 0.0f
#define LEFT_MARGIN 12.0f // 左右边框的
#define MARGIN_BETWEEN_TABS 20.0 // tab间的间距     

@interface TRTabBarView ()

@property (nonatomic, retain) UIScrollView   *mScrollView;
@property (nonatomic, retain) NSMutableArray *mButtons;
@property (nonatomic, retain) UIButton    *mSelectedButton;
@property (nonatomic, retain) UIImageView *mBackgroundView;

@property (nonatomic, retain) UIColor *mNormalTextColor;
@property (nonatomic, retain) UIColor *mSelTextColor;

@end

@implementation TRTabBarView {
    
    CGFloat currentLeftOffSet;
}

- (void)setTabButtonTitle:(UIButton *)btn title:(NSString *)title
{    
    btn.showsTouchWhenHighlighted = NO;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateSelected];
    
    [btn setTitleColor:self.mNormalTextColor forState:UIControlStateNormal];
    [btn setTitleColor:self.mNormalTextColor forState:UIControlStateHighlighted];
    [btn setTitleColor:self.mNormalTextColor forState:UIControlStateSelected];
}

- (id)initWithFrame:(CGRect)frame tabTitles:(NSArray *)titles selectedImage:(UIImage *)image norTextClor:(UIColor *)norTextColor selTextClor:(UIColor *)selTextColor
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];
		_mBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _mBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self insertSubview:_mBackgroundView atIndex:0];
        
        _mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mScrollView.showsHorizontalScrollIndicator = NO;
        _mScrollView.showsVerticalScrollIndicator = NO;
        _mScrollView.scrollsToTop = NO;
        _mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_mScrollView];
        
        self.mNormalTextColor = norTextColor;
        self.mSelTextColor = selTextColor;
                
        NSInteger itemNum = [titles count];
        if (itemNum)
        {
            _mTabTitles = [[NSArray alloc] initWithArray:titles copyItems:YES];
        }
		
        currentLeftOffSet = LEFT_MARGIN;

		self.mButtons = [NSMutableArray arrayWithCapacity:itemNum];
		UIButton *btn;
		for (int i = 0; i < itemNum; i++)
		{
			btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.tag = i;
            [self setTabButtonTitle:btn title:[[titles objectAtIndex:i] valueForKey:@"title"]];
            [self updateFrameForButton:btn withIndex:i];
            
			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[self.mButtons addObject:btn];
			[_mScrollView addSubview:btn];
		}
        
        CGFloat contentSizeWidth = currentLeftOffSet < self.bounds.size.width ? self.bounds.size.width : currentLeftOffSet;
        _mScrollView.contentSize = CGSizeMake(contentSizeWidth, self.bounds.size.height);
        
        _mSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mSelectedButton.showsTouchWhenHighlighted = NO;
        _mSelectedButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _mSelectedButton.frame = CGRectMake(LEFT_MARGIN, TOP_MARGIN, 20.0f, frame.size.height);
        [_mSelectedButton setBackgroundImage:image forState:UIControlStateNormal];
        [_mSelectedButton setTitleColor:self.mSelTextColor forState:UIControlStateNormal];
                
        UIButton *button = [self.mButtons objectAtIndex:0];        
        [self updateSelectedItemToButton:button];
        
        _mSelectedItemIndex = 0;
        
        [_mScrollView addSubview:_mSelectedButton];
    }
    
    return self;
}

- (void)setBackgroundImage:(UIImage *)img
{
	[_mBackgroundView setImage:img];
}

- (void)updateFrameForButton:(UIButton *)btn withIndex:(NSInteger)index
{
    CGFloat width = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + 10;
    btn.frame = CGRectMake(currentLeftOffSet, TOP_MARGIN, width, _mScrollView.bounds.size.height);
    
    currentLeftOffSet = currentLeftOffSet + width;
    
    if ((index + 1) == [self.mTabTitles count]) // the last tab
    {
        currentLeftOffSet = currentLeftOffSet + LEFT_MARGIN;
    }
    else
    {
        currentLeftOffSet = currentLeftOffSet + MARGIN_BETWEEN_TABS;
    }
}

- (void)selectTabBarAtIndex:(NSInteger)index
{
    UIButton *btn = [self.mButtons objectAtIndex:index];
    [self addSelectedEffectForBtn:btn];
}

- (void)updateSelectedItemToButton:(UIButton *)btn
{    
    CGRect frame = _mSelectedButton.frame;
    frame.size.width = [btn.titleLabel.text sizeWithFont:_mSelectedButton.titleLabel.font].width + 10;
    _mSelectedButton.frame = frame;
    
    for (UIButton *btn in self.mButtons)
    {
        btn.titleLabel.textColor = self.mNormalTextColor;
    }
    
    [btn setTitleColor:self.mSelTextColor forState:UIControlStateNormal];
    
    [UIView beginAnimations:@"SelectedItemChangedAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _mSelectedButton.center = btn.center;
    [UIView commitAnimations];
}

- (void)addSelectedEffectForBtn:(UIButton *)btn
{
    [_mScrollView scrollRectToVisible:CGRectMake(btn.frame.origin.x - MARGIN_BETWEEN_TABS / 2, 0, btn.bounds.size.width + MARGIN_BETWEEN_TABS, _mScrollView.bounds.size.height) animated:YES];
    
    _mSelectedItemIndex = btn.tag;
    [self updateSelectedItemToButton:btn];
}

- (void)tabBarButtonClicked:(id)sender
{
	UIButton *btn = sender;
    [self addSelectedEffectForBtn:btn];
    
    if ([_delegate respondsToSelector:@selector(tabBarView:didSelectIndex:)])
    {
        [_delegate tabBarView:self didSelectIndex:btn.tag];
    }
}

@end
