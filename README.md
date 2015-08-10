ScanQRCodeController
====
###A simple tool for scanning QR code

![](https://raw.githubusercontent.com/tx5655/ScanQRCodeController/master/ScanQRCodeDemo/QQ20150810-1%402x.png)

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

* Note
    * 使用系统自带API,需要保证SDK在ios7以上
    * 提供UI样式xib，可以手动调整自己需要的样式
    * 简单方便，快速集成
