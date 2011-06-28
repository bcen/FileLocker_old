#import <Cocoa/Cocoa.h>
#import <openssl/blowfish.h>
#import <openssl/evp.h>

#define DEFAULT_KEY_SIZE 16 //128 bits
#define DEFAULT_IV_SIZE 8 //64 bits
#define BLOCK_SIZE 8
				
@interface Blowfish : NSObject 
{
	EVP_CIPHER_CTX *ctx;
	NSData *_key;
	NSData *_iv;
}

-(id) init;
-(id) initWithIvAndKey;
-(void) dealloc;

-(BOOL) generateKey;
-(BOOL) generateKeyWithSize: (int)size;
-(BOOL) generateIv;
-(BOOL) generateIvAndKey;
-(BOOL) generateIvAndKeyWithSize: (int) size;
-(BOOL) saveKeyToFile: (NSString*)path;
-(BOOL) saveKeyToURL: (NSURL*) url;
-(BOOL) saveIvToFile: (NSString*)path;
-(BOOL) readKeyFromFile: (NSString*)path;
-(BOOL) readKeyFromURL: (NSURL*)url;
-(BOOL) readIvFromFile: (NSString*)path;
-(NSData*) encryptWithData: (NSData*)inData;
-(NSData*) decryptWithData: (NSData*)inData;

@property(readonly) NSData *Key;
@property(readonly) NSData *Iv;

@end
