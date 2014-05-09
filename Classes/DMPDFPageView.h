#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DMPDFPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame page:(CGPDFPageRef)page;

- (void)load;

- (void)unload;

@end