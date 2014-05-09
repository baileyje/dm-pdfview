#import <UIKit/UIKit.h>

@class DMPDFView;

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet DMPDFView* pdfView;

- (IBAction)load;

- (IBAction)close;

@end