#import <UIKit/UIKit.h>

@class DMPDFPage;

@interface DMPDFPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame andPage:(DMPDFPage*)page;

- (void)load;

- (void)unload;

@end