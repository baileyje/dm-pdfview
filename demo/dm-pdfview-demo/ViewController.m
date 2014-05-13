#import <DMPdfView/DMPdfView.h>
#import "ViewController.h"

@implementation ViewController

- (void)load {
    self.pdfView.renderQuality = DMPdfRenderQualityLow;
    [self.pdfView load:[[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"pdf"]];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)close {
    [self.pdfView cleanup];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

@end