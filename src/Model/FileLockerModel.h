#import <Cocoa/Cocoa.h>


@interface FileLockerModel : NSObject 
{
	NSURL *_srcPath;
	NSURL *_destPath;
	NSURL *_keyPath;
}

+(FileLockerModel*) getInstance;
-(void) cleanup;
-(BOOL) generateKeyToURL: (NSURL*)url;
-(BOOL) encrypt;
-(BOOL) decrypt;

@property (retain) NSURL *SourcePath;
@property (retain) NSURL *DestinationPath;
@property (retain) NSURL *KeyPath;
@end