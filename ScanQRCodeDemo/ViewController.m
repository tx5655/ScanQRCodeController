//
//  ViewController.m
//  ScanQRCodeDemo
//
//  Created by 李永路 on 15/8/10.
//  Copyright (c) 2015年 lyl. All rights reserved.
//

#import "ViewController.h"
#import "ScanQRCodeController.h"

@interface ViewController ()
- (IBAction)ScanQRCodeAction:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ScanQRCodeAction:(UIButton *)sender {
    //1 创建
    ScanQRCodeController *scan = [[ScanQRCodeController alloc] init];
    //2 完成后的回调
    scan.ScanQRCodeSuncessBlock = ^(ScanQRCodeController *scan,NSString *string){
        NSLog(@"----%@",string);
        [scan dismissViewControllerAnimated:YES completion:nil];
    };
    //3 由于是控制器，一般选择push或者modal方式
    //    [self.navigationController pushViewController:scan animated:YES];
    
    // modal的方式比较好，可以有点特效duang~~
    scan.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:scan animated:YES completion:nil];
    
}
@end
