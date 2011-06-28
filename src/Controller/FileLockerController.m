#import "FileLockerController.h"


@implementation FileLockerController

-(IBAction) BrowseSource: (id)sender
{
	NSOpenPanel *pnlSrc = [NSOpenPanel openPanel];
	[pnlSrc setCanChooseFiles:YES];
	[pnlSrc setCanChooseDirectories:NO];
	[pnlSrc setAllowsMultipleSelection:NO];
	
	if ([pnlSrc runModal] == NSOKButton)
	{
		FileLockerModel *fileLocker = [FileLockerModel getInstance];
		fileLocker.SourcePath = [[pnlSrc URLs] objectAtIndex: 0];
		fileLocker.DestinationPath = fileLocker.SourcePath;
		[txtSrc setStringValue:[fileLocker.SourcePath absoluteString]];
		[txtDest setStringValue:[fileLocker.DestinationPath absoluteString]];
	}
}

-(IBAction) BrowseDestination: (id)sender
{
	NSSavePanel *pnlDest = [NSSavePanel savePanel];
	[pnlDest setTitle:@"Save File As..."];
	
	if ([pnlDest runModal] == NSOKButton)
	{
		FileLockerModel *fileLocker = [FileLockerModel getInstance];
		fileLocker.DestinationPath = [pnlDest URL];
		[txtDest setStringValue:[fileLocker.DestinationPath absoluteString]];
	}
}

-(IBAction) BrowseKey: (id)sender
{
	NSOpenPanel *pnlKey = [NSOpenPanel openPanel];
	[pnlKey setCanChooseFiles:YES];
	[pnlKey setCanChooseDirectories:NO];
	[pnlKey setAllowsMultipleSelection:NO];
	
	if ([pnlKey runModal] == NSOKButton)
	{
		FileLockerModel *fileLocker = [FileLockerModel getInstance];
		fileLocker.KeyPath = [[pnlKey URLs] objectAtIndex:0];
		[txtKey setStringValue:[fileLocker.KeyPath absoluteString]];
	}
}

-(IBAction) EncryptFile: (id)sender
{
	FileLockerModel *fileLocker = [FileLockerModel getInstance];
	if ([fileLocker encrypt])
		NSRunAlertPanel(@"File Locker", @"Success!", @"OK", nil, nil);
	else
		NSRunAlertPanel(@"File Locker", @"Error", @"OK", nil, nil);

	//[fileLocker cleanup]; //crashed

	[txtSrc setStringValue:@""];
	[txtDest setStringValue:@""];
	[txtKey setStringValue:@""];
}

-(IBAction) DecryptFile: (id)sender
{
	FileLockerModel *fileLocker = [FileLockerModel getInstance];
	if ([fileLocker decrypt])
		NSRunAlertPanel(@"File Locker", @"Success!", @"OK", nil, nil);
	else
		NSRunAlertPanel(@"File Locker", @"Error", @"OK", nil, nil);
	//[fileLocker cleanup]; //crashed
	
	[txtSrc setStringValue:@""];
	[txtDest setStringValue:@""];
	[txtKey setStringValue:@""];
}

-(IBAction) GenerateKey: (id)sender
{
	NSSavePanel *pnlKey = [NSSavePanel savePanel];
	[pnlKey setTitle:@"Save Key As..."];
	
	if ([pnlKey runModal] == NSOKButton)
	{
		FileLockerModel *fileLocker = [FileLockerModel getInstance];
		[fileLocker generateKeyToURL:[pnlKey URL]];
		fileLocker.KeyPath = [pnlKey URL];
		[txtKey setStringValue:[fileLocker.KeyPath absoluteString]];
	}
}

@end
