#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DMPdfView.h"

@class DMPdfPage;


@interface DMPdfPageView : UIView {
    BOOL loaded;
}

@property (nonatomic, readonly) DMPdfPage* page;

- (instancetype)initWithFrame:(CGRect)frame page:(DMPdfPage*)page renderQuality:(DMPdfRenderQuality)quality;

- (void)render;

- (void)clear;

- (CGSize)renderSize;

@end