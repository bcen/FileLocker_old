#import "Blowfish.h"
#import <stdlib.h>
#import <time.h>

@interface Blowfish (Private)
-(NSData*) _encryptWithData: (NSData *)inData;
-(NSData*) _decryptWithData: (NSData*)inData;
@end

@implementation Blowfish (Private)

-(NSData*) _encryptWithData: (NSData*)inData
{
	unsigned char *inBuffer = (unsigned char*)[inData bytes];
	unsigned char *outBuffer = (unsigned char*)malloc(inData.length + 8);
	unsigned char *finalBuffer;
	int outBufferLen, tempLen;
	NSData *outData;
	
	if (EVP_EncryptInit_ex(ctx, EVP_bf_cbc(), NULL, [_key bytes], [_iv bytes]) != 1)
		return nil;	
	if (EVP_EncryptUpdate(ctx, outBuffer, &outBufferLen, inBuffer, [inData length]) != 1)
		return nil;	
	if (EVP_EncryptFinal_ex(ctx, outBuffer + outBufferLen, &tempLen) != 1)
		return nil;
	outBufferLen += tempLen;
	
	finalBuffer = (unsigned char*)malloc(_iv.length + inData.length + 8);
	memcpy(finalBuffer, [_iv bytes], _iv.length);
	memcpy(finalBuffer + _iv.length, outBuffer, outBufferLen);
	
	outData = [[NSData alloc] initWithBytes:finalBuffer length:_iv.length + outBufferLen];
	free(outBuffer);
	free(finalBuffer);

	return [outData autorelease];
	/*
	 unsigned char *inBuffer = (unsigned char*)[inData bytes];
	 unsigned char *outBuffer = (unsigned char*)malloc([inData length] + 8);
	 int outBufferLen, tempLen;
	 NSData *outData;
	 
	 if (EVP_EncryptInit_ex(ctx, EVP_bf_cbc(), NULL, [_key bytes], [_iv bytes]) != 1)
	 return nil;	
	 if (EVP_EncryptUpdate(ctx, outBuffer, &outBufferLen, inBuffer, [inData length]) != 1)
	 return nil;	
	 if (EVP_EncryptFinal_ex(ctx, outBuffer + outBufferLen, &tempLen) != 1)
	 return nil;
	 outBufferLen += tempLen;
	 
	 outData = [[NSData alloc] initWithBytes:outBuffer length:outBufferLen];
	 free(outBuffer);
	 
	 return [outData autorelease];
	 */
}

-(NSData*) _decryptWithData: (NSData*)inData
{
	unsigned char *inBuffer = (unsigned char*)inData.bytes;
	unsigned char *outBuffer = (unsigned char*)malloc(inData.length + 8);
	int outBufferLen = 0, tempLen = 0;
	NSData *outData;
	
	if (_iv != nil)
	{[_iv release]; _iv = nil;}
	
	_iv = [[NSData alloc] initWithBytes:inBuffer length:BLOCK_SIZE];
	
	if (EVP_DecryptInit_ex(ctx, EVP_bf_cbc(), NULL, _key.bytes, _iv.bytes) != 1)
		return nil;				
	if (EVP_DecryptUpdate(ctx, outBuffer, &outBufferLen, inBuffer + BLOCK_SIZE, inData.length - BLOCK_SIZE) != 1)
		return nil;		
	if (EVP_DecryptFinal_ex(ctx, outBuffer + outBufferLen, &tempLen) != 1)
		return nil;
	outBufferLen += tempLen;
	
	outData = [[NSData alloc] initWithBytes:outBuffer length:outBufferLen];
	free(outBuffer);
	
	return [outData autorelease];
	
	/*
	unsigned char *inBuffer = (unsigned char*)inData.bytes;
	unsigned char *outBuffer = (unsigned char*)malloc(inData.length + 8);
	int outBufferLen = 0, tempLen = 0;
	NSData *outData;
	
	if (EVP_DecryptInit_ex(ctx, EVP_bf_cbc(), NULL, _key.bytes, _iv.bytes) != 1)
		return nil;				
	if (EVP_DecryptUpdate(ctx, outBuffer, &outBufferLen, inBuffer, inData.length) != 1)
		return nil;		
	if (EVP_DecryptFinal_ex(ctx, &outBuffer[outBufferLen], &tempLen) != 1)
		return nil;
	outBufferLen += tempLen;
	
	outData = [[NSData alloc] initWithBytes:outBuffer length:outBufferLen];
	free(outBuffer);
	
	return [outData autorelease];
	 */
}

@end


@implementation Blowfish

-(id) init
{
	self = [super init];
	
	if (self)
	{
		srand(time(NULL));
		_key = nil;
		_iv  = nil;
		ctx  = (EVP_CIPHER_CTX*)malloc(sizeof(*ctx));
		EVP_CIPHER_CTX_init(ctx);
	}
	
	return self;
}

-(id) initWithIvAndKey
{
	self = [super init];
	
	if (self)
	{
		srand(time(NULL));
		[self generateIvAndKey];
		ctx  = (EVP_CIPHER_CTX*)malloc(sizeof(*ctx));
		EVP_CIPHER_CTX_init(ctx);
	}
	
	return self;
}

-(void)dealloc
{
	EVP_CIPHER_CTX_cleanup(ctx);
	[_key release];
	[_iv release];
	free(ctx);
	[super dealloc];
}

-(BOOL) generateKey
{
	if (_key != nil)
	{[_key release]; _key = nil;}
	
	unsigned char *buffer = (unsigned char*)malloc(DEFAULT_KEY_SIZE); //16 bytes 128 bits;
	int i;

	
	for (i = 0; i < DEFAULT_KEY_SIZE; i++)
		buffer[i] = rand() % 256;
	
	_key = [[NSData alloc] initWithBytes:buffer length:DEFAULT_KEY_SIZE];
	free(buffer);
	
	if (_key == nil) return NO;
	return YES;
}

-(BOOL) generateKeyWithSize: (int)size
{
	if (_key != nil)
	{[_key release]; _key = nil;}

	unsigned char *buffer = (unsigned char*)malloc(size);
	int i;

	
	for (i = 0; i < size; i++)
		buffer[i] = rand() % 256;
	
	_key = [[NSData alloc] initWithBytes:buffer length:size];
	free(buffer);
	
	if (_key == nil) return NO;
	return YES;
}

-(BOOL) generateIv
{
	if (_iv != nil)
	{[_iv release]; _iv = nil;}
	
	unsigned char *buffer = (unsigned char*)malloc(DEFAULT_IV_SIZE); 
	int i;

	
	for (i = 0; i < DEFAULT_IV_SIZE; i++)
		buffer[i] = rand() % 256;
	
	_iv = [[NSData alloc] initWithBytes:buffer length:DEFAULT_IV_SIZE];
	free(buffer);
	
	if (_iv == nil) return NO;
	return YES;
}

-(BOOL) generateIvAndKey
{
	return [self generateKey] && [self generateIv];
}

-(BOOL) generateIvAndKeyWithSize: (int) size
{
	return [self generateKeyWithSize:size] && [self generateIv];
}

-(BOOL) saveKeyToFile: (NSString*)path
{
	return [_key writeToFile:path atomically:NO];
}

-(BOOL) saveKeyToURL: (NSURL*) url
{
	return [_key writeToURL:url atomically:NO];
}

-(BOOL) saveIvToFile: (NSString*)path
{
	return [_iv writeToFile:path atomically:NO];
}

-(BOOL) readKeyFromFile: (NSString*)path
{
	if (_key != nil)
	{[_key release]; _key = nil;}
	
	_key = [[NSData alloc] initWithContentsOfFile:path];
	
	if (_key == nil) return NO;
	return YES;
}

-(BOOL) readKeyFromURL: (NSURL*)url
{
	if (_key != nil)
	{[_key release]; _key = nil;}
	
	_key = [[NSData alloc] initWithContentsOfURL:url];
	
	if (_key == nil) return NO;
	return YES;
}

-(BOOL) readIvFromFile: (NSString*)path
{
	if (_iv != nil)
	{[_iv release]; _iv = nil;}
	
	_iv = [[NSData alloc] initWithContentsOfFile:path];
	
	if (_iv == nil) return NO;
	return YES;
}

-(NSData*) encryptWithData: (NSData*)inData
{
	/*
	unsigned char *inBuffer = (unsigned char*)[inData bytes];
	unsigned char *outBuffer = (unsigned char*)malloc([inData length] + 8);
	int outBufferLen, tempLen;
	NSData *outData;
	
	if (EVP_EncryptInit_ex(ctx, EVP_bf_cbc(), NULL, [_key bytes], [_iv bytes]) != 1)
		return nil;	
	if (EVP_EncryptUpdate(ctx, outBuffer, &outBufferLen, inBuffer, [inData length]) != 1)
		return nil;	
	if (EVP_EncryptFinal_ex(ctx, outBuffer + outBufferLen, &tempLen) != 1)
		return nil;
	outBufferLen += tempLen;
	
	outData = [[NSData alloc] initWithBytes:outBuffer length:outBufferLen];
	free(outBuffer);
	
	return [outData autorelease];
	 */
	return [self _encryptWithData:inData];
}

-(NSData*) decryptWithData: (NSData*)inData
{
	/*
	unsigned char *inBuffer = (unsigned char*)inData.bytes;
	unsigned char *outBuffer = (unsigned char*)malloc(inData.length + 8);
	int outBufferLen = 0, tempLen = 0;
	NSData *outData;
	
	if (EVP_DecryptInit_ex(ctx, EVP_bf_cbc(), NULL, _key.bytes, _iv.bytes) != 1)
		return nil;				
	if (EVP_DecryptUpdate(ctx, outBuffer, &outBufferLen, inBuffer, inData.length) != 1)
		return nil;		
	if (EVP_DecryptFinal_ex(ctx, &outBuffer[outBufferLen], &tempLen) != 1)
		return nil;
	outBufferLen += tempLen;
	
	outData = [[NSData alloc] initWithBytes:outBuffer length:outBufferLen];
	free(outBuffer);
	
	return [outData autorelease];
	 */
	
	return [self _decryptWithData:inData];
}

@synthesize Key = _key;
@synthesize Iv = _iv;

@end
