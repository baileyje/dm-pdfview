#import <DMPDFView/DMPDFView.h>
#import "ViewController.h"
#import "DMPDFView.h"
#import "PreviewUtil.h"

@implementation ViewController

- (void)load {
    self.pdfView.renderQuality = DMPDFRenderQualityLow;
    [self.pdfView load:[[NSBundle mainBundle] URLForResource:@"test" withExtension:@"pdf"]];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)close {
    [self.pdfView cleanup];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

@end