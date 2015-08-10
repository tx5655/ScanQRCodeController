//
//  ScanQRCodeController.h
//  pinpinpiture
//
//  Created by LYL on 15/7/8.
//  Copyright (c) 2015年 LYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ScanQRCodeController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, copy) void (^ScanQRCodeSuncessBlock) (ScanQRCodeController *,NSString *);//扫描结果
@end
