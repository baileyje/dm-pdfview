#import <UIKit/UIKit.h>

@class DMPdfDocument;

@protocol DMPdfIndexViewDelegate
- (void)indexPageSelected:(NSUInteger)page;
@end


@interface DMPdfIndexView : UIView

@property (nonatomic, assign) id<DMPdfIndexViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andDocument:(DMPdfDocument*)document cachePages:(BOOL)cache;

- (void)highlight:(NSUInteger)page;

@end