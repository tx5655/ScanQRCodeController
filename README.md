ScanQRCodeController
====
###A simple tool for scanning QR code
* Usage
```c
#import "ScanQRCodeController.h"
```

```objective-c
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

```
