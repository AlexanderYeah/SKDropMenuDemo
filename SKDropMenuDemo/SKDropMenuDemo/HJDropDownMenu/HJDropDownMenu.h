//
//  HJDropDownMenu.h
//  ZongHeng
//
//  Created by WHJ on 2017/9/5.
//  Copyright © 2017年 zonghenggongkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJDropDownMenu : UIView

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) NSArray * datas;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, strong) UIFont * font;
//选中后自动收起
@property (nonatomic, assign) BOOL autoCloseWhenSelected;

//选中回调
@property (nonatomic, copy) void(^cellClickedBlock)(NSString *title,NSInteger index);


- (void)closeMenu;


@end
