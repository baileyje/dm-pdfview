#import <UIKit/UIKit.h>

@class DMPdfView;

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet DMPdfView* pdfView;

- (IBAction)load;

- (IBAction)close;

@end