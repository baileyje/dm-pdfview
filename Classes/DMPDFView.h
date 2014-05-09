#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DMPDFView : UIView

- (void)load:(NSURL*)pdfUrl;

- (void)clearContent;

- (void)scrollToPage:(int)page;
@end