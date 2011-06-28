#import <Cocoa/Cocoa.h>
#import "../Model/FileLockerModel.h"

@interface FileLockerController : NSObject {
	IBOutlet NSTextField *txtSrc;
	IBOutlet NSTextField *txtDest;
	IBOutlet NSTextField *txtKey;
	IBOutlet NSButton    *btnSrcBrowse;
	IBOutlet NSButton    *btnDestBrowse;
	IBOutlet NSButton    *btnKeyBrowse;
	IBOutlet NSButton    *btnEncrypt;
	IBOutlet NSButton    *btnDecrypt;
	IBOutlet NSButton    *btnGenerate;
}

-(IBAction) BrowseSource: (id)sender;
-(IBAction) BrowseDestination: (id)sender;
-(IBAction) BrowseKey: (id)sender;
-(IBAction) EncryptFile: (id)sender;
-(IBAction) DecryptFile: (id)sender;
-(IBAction) GenerateKey: (id)sender;
@end
