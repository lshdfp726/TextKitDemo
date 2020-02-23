//
//  TextKitViewController.m
//  TextKit
//
//  Created by lsh726 on 2020/2/23.
//  Copyright © 2020 liusonghong. All rights reserved.
//

#import "TextKitViewController.h"

@interface TextKitViewController ()
@property (strong, nonatomic) IBOutlet UITextView *tv;

@property (strong, nonatomic) NSTextContainer *textContainer;
@end

@implementation TextKitViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect textViewRect = CGRectInset(self.view.frame, 10, 20);
    NSTextStorage *storage = [[NSTextStorage alloc] initWithString:_tv.text];
    NSLayoutManager *manager = [[NSLayoutManager alloc] init];
    [storage addLayoutManager:manager];

    self.textContainer = [[NSTextContainer alloc] initWithSize:textViewRect.size];
    [manager addTextContainer:self.textContainer];

    [_tv removeFromSuperview];
    _tv = [[UITextView alloc] initWithFrame:textViewRect textContainer:self.textContainer];
    [self.view addSubview:_tv];

    [storage beginEditing];
    NSDictionary *attr = @{NSTextEffectAttributeName: NSTextEffectLetterpressStyle};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_tv.text attributes:attr];
    [storage setAttributedString:attrStr];
    [self markWord:@"蝴蝶" inTextStorage:storage];
    [storage endEditing];

    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(preferredContentSizeChanged:)
        name:UIContentSizeCategoryDidChangeNotification
      object:nil];

    //设置环绕路径，类似word 的图文混排的作用
//    _tv.textContainer.exclusionPaths

}

- (void)preferredContentSizeChanged:(NSNotification *)notification {
    self.tv.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)markWord:(NSString *)word inTextStorage:(NSTextStorage *)textStorage {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:word options:0 error:nil];
    NSArray *matches = [regex matchesInString:_tv.text options:0 range:NSMakeRange(0, [_tv.text length])];

    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        [textStorage addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:range];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
