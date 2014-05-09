#import <DMPDFView/DMPDFView.h>
#import "ViewController.h"
#import "DMPDFView.h"

@implementation ViewController

- (void)load {
    [self.pdfView load:[[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"pdf"]];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)close {
    [self.pdfView clearContent];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

@end