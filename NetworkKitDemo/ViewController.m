//
//  ViewController.m
//  NetworkKitDemo
//
//  Created by 支舍社 on 2017/5/23.
//  Copyright © 2017年 支舍社. All rights reserved.
//

#import "ViewController.h"
#import "NET_APIManager+Common.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NET_APIManager getServerTime] setCompletionHandler:^(NET_Error *error, id object) {
        if (!error) {
            
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
