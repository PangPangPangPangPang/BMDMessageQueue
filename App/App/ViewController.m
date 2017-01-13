//
//  ViewController.m
//  App
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "ViewController.h"
#import <BMDMessageQueue/BMDMessageQueue.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BMDTaskManager *manager = [BMDTaskManager new];
    NSMutableDictionary *container = [NSMutableDictionary new];
    [container setValue:[NSClassFromString(@"BMDSleepActor") new] forKey:@"sleep"];
    [container setValue:[NSClassFromString(@"BMDDeeperActor") new] forKey:@"deeper"];
    [manager prepareForContainer:container];
    [[BMDMessageQueue getInstance] prepareWithTaskManager:manager];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton new];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn setFrame:CGRectMake(199, 199, 199, 199)];
    [btn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)tap {
    BMDMessage *message = [[BMDMessage alloc] initWithTask:@"sleep" args:nil];
    [self sendMessage:message callBack:@selector(getSleepCallback:)];
}
- (void)getSleepCallback:(BMDMessage *)message {
    NSLog(@"%@",message.dataTable);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
