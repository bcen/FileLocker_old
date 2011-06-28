#import "FileLockerModel.h"
#import "../Security/Blowfish.h"

@implementation FileLockerModel

static FileLockerModel *fileLocker = nil;

+(FileLockerModel*) getInstance
{
	@synchronized(self)
	{
		if (fileLocker == nil)
		{
			fileLocker = [[self alloc] init];
		}
	}
	
	return fileLocker;
}

-(void) cleanup
{
	[_srcPath release];
	[_destPath release];
	[_keyPath release];
}

-(BOOL) generateKeyToURL: (NSURL*)url
{
	BOOL flag = NO;
	
	Blowfish *bf = [[Blowfish alloc] init];
	[bf generateKey];
	[bf saveKeyToURL:url];
	[bf release];
	
	return flag;
}

-(BOOL) encrypt
{
	Blowfish *bf = [[Blowfish alloc] init];
	[bf generateIv];
	[bf readKeyFromURL:_keyPath];
	NSData *plain = [[NSData alloc] initWithContentsOfURL:_srcPath];
	NSData *cipher = [bf encryptWithData:plain];
	
	[bf release];
	[plain release];
	
	if ([cipher writeToURL:_destPath atomically:NO] == NO)
		return NO;
	return YES;
}

-(BOOL) decrypt
{
	Blowfish *bf = [[Blowfish alloc] init];
	[bf readKeyFromURL:_keyPath];
	NSData *cipher = [[NSData alloc] initWithContentsOfURL:_srcPath];
	NSData *plain = [bf decryptWithData:cipher];
	
	[bf release];
	[cipher release];
	
	if ([plain writeToURL:_destPath atomically:NO] == NO)
		return NO;
	return YES;
}

@synthesize SourcePath = _srcPath;
@synthesize DestinationPath = _destPath;
@synthesize KeyPath = _keyPath;
@end
