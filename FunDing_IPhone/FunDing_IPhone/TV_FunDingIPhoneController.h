//
//  TV_FunDingIPhoneController.h
//  FunDing_IPhone
//
//  Created by apple on 12-11-9.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TV_FunDingIPhoneController : UITableViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblAddr;
@property (strong, nonatomic) IBOutlet UIImageView *imageHot;

@property (strong, nonatomic) IBOutlet UIViewController *uv_maps;

@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSArray *imageList;

@end
