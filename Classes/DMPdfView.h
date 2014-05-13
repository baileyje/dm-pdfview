#import <UIKit/UIKit.h>

typedef enum {
    DMPdfRenderQualityHigh,
    DMPdfRenderQualityMedium,
    DMPdfRenderQualityLow
} DMPdfRenderQuality;

@interface DMPdfView : UIView

@property (nonatomic) NSUInteger currentPage;

@property (nonatomic) NSUInteger pageBuffer;

@property (nonatomic) BOOL showsPageNumber;

@property (nonatomic) BOOL pageNumberVisible;

@property (nonatomic) BOOL showsIndex;

@property (nonatomic) BOOL indexVisible;

@property (nonatomic) CGFloat indexWidth;

@property (nonatomic) DMPdfRenderQuality renderQuality;

@property (nonatomic) BOOL cachePages;

- (void)load:(NSURL*)pdfUrl;

- (void)cleanup;

- (void)scrollToPage:(NSUInteger)page;

- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated;

- (void)showPageNumber;

- (void)hidePageNumber;

- (void)toggleIndex;

- (void)showIndex;

- (void)hideIndex;

@end
