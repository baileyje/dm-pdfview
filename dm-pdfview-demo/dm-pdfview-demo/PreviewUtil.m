#import "PreviewUtil.h"
#import <QuickLook/QuickLook.h>

@interface PreviewUtil () <QLPreviewControllerDataSource, QLPreviewControllerDelegate, QLPreviewItem>
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSURL *url;
@end


@implementation PreviewUtil

static PreviewUtil *CURRENT;

+(void)preview:(NSURL*)url from:(UIViewController *)viewController {
    if (!CURRENT) {
        CURRENT = [PreviewUtil new];
    }
    CURRENT.url = url;
    CURRENT.title = @"Nice!!";
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = CURRENT;
    previewController.delegate = CURRENT;
    [viewController presentViewController:previewController animated:YES completion:nil];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self;
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    controller.delegate = nil;
    controller.dataSource = nil;
}

- (NSURL *)previewItemURL {
    return self.url;
}

- (NSString *)previewItemTitle {
    return self.title;
}

@end
