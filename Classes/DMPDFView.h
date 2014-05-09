#import <UIKit/UIKit.h>

@interface DMPDFView : UIView

@property (nonatomic) BOOL showsIndex;

- (void)load:(NSURL*)pdfUrl;

- (void)clearContent;

- (void)goto:(NSUInteger)page;

- (void)goto:(NSUInteger)page animated:(BOOL)animated;

- (void)toggleIndex;

- (void)showIndex;

- (void)hideIndex;

@end