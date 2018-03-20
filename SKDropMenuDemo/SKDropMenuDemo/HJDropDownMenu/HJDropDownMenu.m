//
//  HJDropDownMenu.m
//  ZongHeng
//
//  Created by WHJ on 2017/9/5.
//  Copyright © 2017年 zonghenggongkao. All rights reserved.
//

#import "HJDropDownMenu.h"
#import "UIView+MJExtension.h"

@interface HJDropDownMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *listTable;

@property (nonatomic, strong) UIButton *headerBtn;

@property (nonatomic, assign) BOOL headerSelected;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;


@end

static NSString * const kDropMenuCellIdentifier = @"DropMenuCellIdentifier";
static const CGFloat kCellDefaultHeight = 44.f;

@implementation HJDropDownMenu

#pragma mark - Life Circle
-(instancetype)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        [self configData];
        [self setupUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configData];
        [self setupUI];
    }
    return self;
}


- (void)configData{

    self.indicatorColor = [UIColor blackColor];
    
    self.textColor = [UIColor blackColor];
    
    self.font = [UIFont systemFontOfSize:14.f];

}
#pragma mark - About UI
- (void)setupUI{

    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.listTable];
	
	self.listTable.scrollEnabled = NO;
    
    [self.listTable setFrame:CGRectMake(0, 0, self.mj_h, kCellDefaultHeight)];
    [self.listTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kDropMenuCellIdentifier];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.headerSelected) {
        self.mj_h = self.datas.count*self.rowHeight + self.rowHeight;
    }else{
        self.mj_h = self.rowHeight;
    }
    self.listTable.frame = self.bounds;
}
#pragma mark - Event response
- (void)sectionHeaderClicked{

    self.headerSelected = !self.headerSelected;
    [self setNeedsLayout];
    __weak typeof(self) weakSelf = self;
    [self animateIndicator:self.shapeLayer Forward:self.headerSelected complete:^{
        [weakSelf cellInsertOrDelete:self.headerSelected];
    }];
    
    
    
}
#pragma mark - Pravite Method
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}


- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    complete();
}


- (void)cellInsertOrDelete:(BOOL)insert{
    
    [self.listTable beginUpdates];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.datas.count];
    
    [self.datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:idx inSection:0];
        [indexPaths addObject:indexP];
    }];
    
    if (insert) {
        [self.listTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }else{
        [self.listTable deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
    }
    
    
    
    [self.listTable endUpdates];
}
#pragma mark - Public Method
- (void)closeMenu{
    if (self.headerSelected) {
        [self sectionHeaderClicked];
    }
}
#pragma mark - Getters/Setters/Lazy
- (UITableView *)listTable{
    if (!_listTable) {
        _listTable = [[UITableView alloc] init];
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTable.delegate = self;
        _listTable.dataSource = self;
    }
    return _listTable;
}


- (void)setDatas:(NSArray *)datas{
    _datas = datas;
    
    [self.listTable reloadData];
}


- (void)setRowHeight:(CGFloat)rowHeight{
    _rowHeight = rowHeight;
    
    [self setNeedsDisplay];
}
#pragma mark - Delegate methods

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.headerSelected?self.datas.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDropMenuCellIdentifier];
    cell.textLabel.text = self.datas[indexPath.row];
    cell.textLabel.font = self.font;
    cell.textLabel.textColor = self.textColor;
    cell.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.headerBtn setTitle:self.datas[indexPath.row] forState:UIControlStateNormal];
    
    if(self.cellClickedBlock){
        self.cellClickedBlock(self.datas[indexPath.row], indexPath.row);
		[self closeMenu];
    }
    
    
    if (self.autoCloseWhenSelected) {
        [self closeMenu];
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton *headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.mj_w, self.rowHeight==0?kCellDefaultHeight:self.rowHeight)];
    headerBtn.titleLabel.font = self.font;
    [headerBtn setTitleColor:self.textColor forState:UIControlStateNormal];
    [headerBtn setTitle:self.datas[0] forState:UIControlStateNormal];
    [headerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [headerBtn addTarget:self action:@selector(sectionHeaderClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CGPoint position = CGPointMake(headerBtn.mj_w-10,headerBtn.mj_h/2.f);
    CAShapeLayer *shapeLayer = [self createIndicatorWithColor:self.indicatorColor andPosition:position];
    [headerBtn.layer addSublayer:shapeLayer];
    
    
    self.shapeLayer = shapeLayer;
    self.headerBtn = headerBtn;
    return headerBtn;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.rowHeight==0?kCellDefaultHeight:self.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return self.rowHeight==0?kCellDefaultHeight:self.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}

@end
