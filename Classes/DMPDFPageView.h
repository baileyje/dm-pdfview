#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DMPDFView.h"

@class DMPDFPage;


@interface DMPDFPageView : UIView {
    BOOL loaded;
}

@property (nonatomic, readonly) DMPDFPage* page;

- (instancetype)initWithFrame:(CGRect)frame page:(DMPDFPage*)page renderQuality:(DMPDFRenderQuality)quality;

- (void)render;

- (void)clear;

- (CGSize)renderSize;

@end