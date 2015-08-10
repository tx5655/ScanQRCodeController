//
//  ScanQRCodeController.m
//  pinpinpiture
//
//  Created by LYL on 15/7/8.
//  Copyright (c) 2015年 LYL. All rights reserved.
//

#define ScanQRCodeResName           @"ScanQRCodeRes.bundle"

#define ScanQRCodeSourceName(file) [ScanQRCodeResName stringByAppendingPathComponent:file]

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#import "ScanQRCodeController.h"
//#import "Masonry.h"

@interface ScanQRCodeController ()
@property (weak, nonatomic) IBOutlet UIImageView *scanWindow;
@property (weak, nonatomic) IBOutlet UIImageView *lineView;

- (IBAction)cancelScan:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;


@property (nonatomic,assign) BOOL upOrdown;
@property (nonatomic,assign) int num;
@property (nonatomic,strong) NSTimer * timer;


@end

@implementation ScanQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _scanWindow.image = [UIImage imageNamed:ScanQRCodeSourceName(@"erweima")];
    _lineView.image = [UIImage imageNamed:ScanQRCodeSourceName(@"ff_07")];
    

    
}


- (IBAction)cancelScan:(UIButton *)sender {
    [_timer invalidate];
    
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)animation1
{
    if (_upOrdown == NO) {
        _num ++;
//        _lineView.frame = CGRectMake(50, 110+2*_num, 220, 2);
        _lineView.transform = CGAffineTransformMakeTranslation(0, 2*_num);
        if (2*_num == 270) {
            _upOrdown = YES;
        }
    }
    else {
        _num --;
//        _lineView.frame = CGRectMake(50, 110+2*_num, 220, 2);
        _lineView.transform = CGAffineTransformMakeTranslation(0, 2*_num);
        if (_num == 0) {
            _upOrdown = NO;
        }
    }
    
}
// 在此之前的控件frame都是不准确的
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupCamera];
    
    _upOrdown = NO;
    _num =0;
    [self.view addSubview:_lineView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    // 2. 设置输入
    // 因为模拟器是没有摄像头的，因此在此最好做一个判断:-)
    NSError *error = nil;
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        
        return;
    }
    
    
    CGFloat previewX = (self.scanWindow.frame.origin.x + 4)/SCREENWIDTH;
    CGFloat previewY = (self.scanWindow.frame.origin.y + 4)/SCREENHEIGHT;
    CGFloat previewW = (self.scanWindow.frame.size.width - 8)/SCREENWIDTH;
    CGFloat previewH = (self.scanWindow.frame.size.width - 8)/SCREENHEIGHT;
    // x和y需要对调，w和h也需要对调(取值0-1),暂时不知道原因
    CGRect rect = CGRectMake(previewY, previewX, previewH, previewW);
    // Output
    //设置输出的代理
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 设置实际取景框的大小
    [_output setRectOfInterest:rect];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
//    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    // 读取质量，质量越高，可读取小尺寸的二维码
    if ([_session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
    {
        [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        [_session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    else
    {
        [_session setSessionPreset:AVCaptureSessionPresetPhoto];
    }

    
    
    
    // 条码类型 AVMetadataObjectTypeQRCode   AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // 给取景框 留出点间距，好看一点
//    CGFloat previewX = self.scanWindow.frame.origin.x + 4;
//    CGFloat previewY = self.scanWindow.frame.origin.y + 4;
//    CGFloat previewW = self.scanWindow.frame.size.width - 8;
//    CGFloat previewH = previewW;
//    
//    _preview.frame = CGRectMake(previewX, previewY, previewW, previewH);
    
    _preview.frame = self.view.layer.bounds;
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    
    [_session stopRunning];
    
    [_timer invalidate];
    // 拿到二维码的内容
    [self sendQRCode:stringValue];
    
    if (self.ScanQRCodeSuncessBlock) {
        self.ScanQRCodeSuncessBlock(self,stringValue);
    }
    
    
}
// 拿到二维码的内容,进一步处理
- (void)sendQRCode:(NSString *)QRCode
{
    self.descriptionLabel.text = QRCode;
}




@end
