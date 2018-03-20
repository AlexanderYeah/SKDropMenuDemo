//
//  ViewController.m
//  SKDropMenuDemo
//
//  Created by AY on 2018/3/20.
//  Copyright © 2018年 AY. All rights reserved.
//

#import "ViewController.h"
#import "HJDropDownMenu.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
    HJDropDownMenu * typeMenu = [[HJDropDownMenu alloc] initWithFrame:CGRectMake(50, 100, 100, 24)];
    typeMenu.rowHeight = 24;
	typeMenu.cellClickedBlock = ^(NSString *title, NSInteger index) {
		NSLog(@"%@",title);
		
	};
    typeMenu.datas = @[@"已审核",@"未审核",@"不审核"];
    [self.view addSubview:typeMenu];
	
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
