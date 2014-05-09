#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DMPDFPage;


@interface DMPDFPageView : UIView {
    BOOL loaded;
}

@property (nonatomic, readonly) DMPDFPage* page;

- (instancetype)initWithFrame:(CGRect)frame andPage:(DMPDFPage*)page;

- (void)load;

- (void)unload;

@end