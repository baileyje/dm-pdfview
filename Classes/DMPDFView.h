#import <UIKit/UIKit.h>

typedef enum {
    DMPDFRenderQualityHigh,
    DMPDFRenderQualityMedium,
    DMPDFRenderQualityLow
} DMPDFRenderQuality;

@interface DMPDFView : UIView

@property (nonatomic) NSUInteger currentPage;

@property (nonatomic) NSUInteger pageBuffer;

@property (nonatomic) BOOL showsPageNumber;

@property (nonatomic) BOOL pageNumberVisible;

@property (nonatomic) BOOL showsIndex;

@property (nonatomic) BOOL indexVisible;

@property (nonatomic) CGFloat indexWidth;

@property (nonatomic) DMPDFRenderQuality renderQuality;

- (void)load:(NSURL*)pdfUrl;

- (void)cleanup;

- (void)goto:(NSUInteger)page;

- (void)goto:(NSUInteger)page animated:(BOOL)animated;

- (void)showPageNumber;

- (void)hidePageNumber;

- (void)toggleIndex;

- (void)showIndex;

- (void)hideIndex;

@end
