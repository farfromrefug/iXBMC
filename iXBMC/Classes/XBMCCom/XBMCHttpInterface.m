/*

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/
#import "XBMCHttpInterface.h"
#import <Foundation/NSURL.h>
#import "Utilities.h"

static XBMCHttpInterface *sharedInstance = nil;

@implementation XBMCHttpInterface
@synthesize fulladdress = _fulladdress;

+ (XBMCHttpInterface *) sharedInstance {
	return ( sharedInstance ? sharedInstance : ( sharedInstance = [[self alloc] init] ) );
}

-(id)init{
    self = [super init];
    self.fulladdress = @"";
	
	return self;	
}

- (void)dealloc;
{
    TT_RELEASE_SAFELY(_fulladdress);
	[super dealloc];
}


- (void) setAddress:(NSString*)address port:(NSString*)port login:(NSString*)log password:(NSString*)pwd
{
    NSString* newfulladdress = [NSString stringWithFormat:@"%@:%@@%@:%@",log,pwd,address,port];
    if (_fulladdress && [newfulladdress compare:_fulladdress] == NSOrderedSame) return;
    //    fulladdress = @"test";
    self.fulladdress = newfulladdress;
    NSLog(@"fulladdress: %@", _fulladdress);
    //[newfulladdress release];
}

-(NSString*)XbmcIPAddress
{
//    NSString* test = [XBMCCommunicator sharedInstance].fulladdress;
    return _fulladdress;
}

-(NSString*)createURLBase
{
	NSString *s = [NSString stringWithFormat:@"http://%@/xbmcCmds/xbmcHttp?command=", _fulladdress];
    return s;
}

-(NSData*)getXBMCFile: (NSString*) url
{
	NSString *s = [NSString stringWithFormat:@"http://%@/vfs/%@", [self XbmcIPAddress], url];
    return [Utilities getCachedFile:s];
}

+(NSString*)getUrlFromSpecial: (NSString*) url
{
    
    NSString *s = [NSString stringWithFormat:@"http://%@/vfs/%@"
                   , [[XBMCHttpInterface sharedInstance] XbmcIPAddress], url];
    return s;
}
-(UIImage*)getImageFromSpecial: (NSString*) url
{
    
    NSString *s = [NSString stringWithFormat:@"http://%@/vfs/%@", [self XbmcIPAddress], url];
    return [UIImage imageWithData:[Utilities getCachedFile:s]];
}

-(BOOL)isNumeric:(NSString*)str
{
   int anInteger;
   NSScanner *aScanner = [NSScanner scannerWithString:str];
   return [aScanner scanInt:&anInteger];
}

-(NSString*) encodeURL: (NSString*)urlString
{
   NSMutableString *encodedURL = [NSMutableString stringWithCapacity:20];
   [encodedURL setString: urlString];
   // 
   int i;
   for (i=32;i<46;++i)
   {
      if (i==37)continue;
      NSString* charToBeReplaced = [NSString stringWithFormat:@"%C", i];
	  NSString* charToReplace = [@"%" stringByAppendingString:[NSString stringWithFormat:@"%x", i]];
      [encodedURL replaceOccurrencesOfString: charToBeReplaced withString:charToReplace options:NSCaseInsensitiveSearch range:NSMakeRange(0, [encodedURL length])];
   }
   [encodedURL replaceOccurrencesOfString: @"\\" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [encodedURL length])];

   return encodedURL;   
}

-(NSString*) getPage: (NSString*) urlString timeout: (double) timeoutVal
{
//    NSLog(@"getPage: %@", urlString);
    NSURL* url = [NSURL URLWithString: urlString];
   
    NSURLRequest* request = [NSURLRequest requestWithURL: url
                        cachePolicy:NSURLRequestUseProtocolCachePolicy
						timeoutInterval:timeoutVal];
    NSData *responseData;
    NSError        *error = nil;
    NSURLResponse  *response = nil;

	responseData = [ NSURLConnection sendSynchronousRequest:request
		returningResponse:&response error:&error];

    NSString *page;		
	if (error &&[error code]) {
		   page = [NSString stringWithFormat:@"Err: %@ %d %@ %@", [ error domain], [ error code], [ error localizedDescription], request];
		   NSLog(@"Page Load %@", page);
    }       
	else
	{
	   // convert tostring
	   page = [[[NSString alloc] initWithData: responseData encoding:[NSString defaultCStringEncoding]] autorelease];
	   if ([page rangeOfString:@"xbmcHttp is not defined"].location != NSNotFound)
	   {
	      page = @"Err: xbmcHTTP not found";
	   }
	}
//	NSLog(@"getPage: done");
	return page;
}

-(int)getNumericResponse: (NSString*) resp
{
   NSLog(@"getNumericResponse");
   int returnVal;
   NSMutableArray *theLines = [[NSMutableArray alloc] initWithCapacity:10];
   if([self getLines: resp lines: theLines] > 0)
   {
      NSString *identifier = [theLines objectAtIndex:0];
	  if ([self isNumeric: identifier])
	  {
	     NSLog(@"getNumericResponse: identifier = %@", identifier);
	     returnVal = [identifier intValue];
	  }
	  else{
	    returnVal = -2;
	  }
   }
   else
   {
      returnVal = -2;
   }
   [theLines release];
   NSLog(@"getNumericResponse: returning = %d", returnVal);
   return returnVal;
}
		
-(NSString*)getStringResponse: (NSString*)resp
{
    NSString *theString;
	NSMutableArray *theLines = [[NSMutableArray alloc] initWithCapacity:10];
    if([self getLines: resp lines: theLines] > 0)
    {
      theString = [theLines objectAtIndex:0];
	}
	else
	{
	  theString = @"";
	}
	[theLines release];
	return theString;
}
		
-(int)getLines: (NSString*) text lines: (NSMutableArray*)theLines
{
   // Note: uncomment this to see the text
   //NSLog(@"getLines:  %@", text);
   int p, p1;
   NSString* tmp;
   p = (int)[text rangeOfString:@"<li>"].location;
   while((p!=NSNotFound))
   {
      NSString *s = [NSString stringWithFormat:@"%C", 0xa];
      p1 = (int)[text rangeOfString:s options:NSLiteralSearch range: NSMakeRange(p, [text length] - p)].location;
	  if (p1 == NSNotFound)
	  {
	     p1 = [text length];
	  }
	  tmp = [text substringWithRange:NSMakeRange(p+4,p1-p-4)];
	  if ([[tmp substringWithRange:NSMakeRange([tmp length]-1,1)] compare: @">"] == NSOrderedSame)
	  {
	     p = [tmp rangeOfString:@"<" options:NSBackwardsSearch ].location;
		 if (p != NSNotFound)
		 {
		    tmp = [tmp substringWithRange:NSMakeRange(0, p)];
		 }
	  }
	  //NSLog(@"found a line: %@", tmp);
	  [theLines addObject: tmp];
	  p = (int)[text rangeOfString:@"<li>" options:NSCaseInsensitiveSearch range: NSMakeRange(p1, [text length] - p1)].location;
   }
   NSLog(@"getLines:  done");
   return ([theLines count] > 0);
}

-(int)getCurrentPlaylistIndex
{
   return [self getNumericResponse:[self getPage: [self getXbmcURLForCommand:@"getcurrentplaylist"] timeout: 3.0]];
}

-(void)setCurrentPlaylistIndex:(int) index
{
   NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:1]; 
   [paramArray addObject:[NSString stringWithFormat:@"%d", index]];
   [self getPage: [self getXbmcURLForCommand:@"setcurrentplaylist" parameters:paramArray] timeout: 3.0];
   [paramArray release];
}

-(BOOL)isSomethingPlaying
{
   NSMutableArray *theLines = [[NSMutableArray alloc] initWithCapacity:10];
   [self getLines: [self getPage: [self getXbmcURLForCommand:@"getcurrentlyplaying"] timeout: 3.0] lines: theLines];
   if ([theLines count] != 0 && NSNotFound == [[theLines objectAtIndex:0] rangeOfString:@"[Nothing Playing]" options:NSCaseInsensitiveSearch].location)
   {
      return YES;
   }
   else
   {
      return NO;
   }
}

-(void)setPlaylistSong:(int)index
{
	NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:1]; 
   [paramArray addObject:[NSString stringWithFormat:@"%d", index]];
   [self getPage: [self getXbmcURLForCommand:@"setplaylistsong" parameters:paramArray] timeout: 3.0];
   [paramArray release];
}


-(BOOL)checkOnline
{
   if (-2 < [self getCurrentPlaylistIndex])
   {
      return YES;
   }
   else
   {
      return NO;
   }
}

-(void)stop
{
     [self getPage: [self getXbmcURLForCommand:@"stop"] timeout: 3.0];
}

-(void)playFile:(NSString*)path
{
   // JOEBUG:  calling stop will set the current playlist to -1.  This means the previous playlist will not resume when the song is done
   // I've disabled this behavior for now
   //[self stop];
   
   NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:1];
   [paramArray addObject:path];
   [self getPage: [self getXbmcURLForCommand:@"playfile" parameters:paramArray] timeout: 3.0];
   [paramArray release];
}

-(void)queueFile:(NSString*)path
{
   // get current playlist.   
   int playlistIndex = [self getCurrentPlaylistIndex];
   if (playlistIndex < 0)
   {
		playlistIndex = 0;
		[self setCurrentPlaylistIndex:playlistIndex];
   }
   NSString *playlistIndexString = [NSString stringWithFormat:@"%d", playlistIndex];
   NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:1];
   [paramArray addObject:path];
   [paramArray addObject:playlistIndexString];
   [self getPage: [self getXbmcURLForCommand:@"addtoplaylist" parameters:paramArray] timeout: 3.0];
   [paramArray release];
   
   // autostart
   if ([self isSomethingPlaying] == NO)
   {
      [self setPlaylistSong:0];
   }
}

-(NSMutableDictionary*)getFileInfo:(NSString*)path
{
	int i;
	NSMutableDictionary *itemInfo = [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
	NSMutableArray *theLines = [[NSMutableArray alloc] initWithCapacity:10];
	NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:1];
    [paramArray addObject:path];
    [self getLines: [self getPage: [self getXbmcURLForCommand:@"GetTagFromFilename" parameters:paramArray] timeout: 3.0] lines: theLines];
	[paramArray release];
	for (i=0; i<[theLines count]; ++i)
	{
		NSArray *arr = [[theLines objectAtIndex:i] componentsSeparatedByString:@":"];
		if ([arr count] > 1)
		{
			[itemInfo setValue:[arr objectAtIndex:1] forKey:[arr objectAtIndex:0]];
		}
	}
	[theLines release];
	return itemInfo;
}

-(NSMutableDictionary*)getCurrentlyPlayingInfo
{
	int i;
	NSMutableDictionary *itemInfo = [[NSMutableDictionary alloc] initWithCapacity:5];
	NSMutableArray *theLines = [[NSMutableArray alloc] initWithCapacity:10];
	NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:1];
    [paramArray addObject:@"q:\\web\\thumb.jpg"];
    [self getLines: [self getPage: [self getXbmcURLForCommand:@"GetCurrentlyPlaying" parameters:paramArray] timeout: 3.0] lines: theLines];
	[paramArray release];
	for (i=0; i<[theLines count]; ++i)
	{
		int p = (int)[[theLines objectAtIndex:i] rangeOfString:@":"].location;
		if (p!=NSNotFound)
		{
		   [itemInfo setValue:[[theLines objectAtIndex:i] substringFromIndex:p+1] forKey:[[theLines objectAtIndex:i] substringToIndex:p]];
		}
	}
	if ([[itemInfo valueForKey:@"Filename"] caseInsensitiveCompare: @"[Nothing Playing]"] == NSOrderedSame)
	{
		[itemInfo release];
		itemInfo = nil;
	}
	else
	{
		[itemInfo autorelease];
	}
	[theLines release];
	return itemInfo;
}

-(float)getVolume
{
	return 1.0 * [self getNumericResponse:[self getPage: [self getXbmcURLForCommand:@"GetVolume"] timeout: 3.0]];
}

-(void)setVolume:(float)volume
{
	NSString *volumeString = [NSString stringWithFormat:@"%d", (int)volume];
    NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:1];
    [paramArray addObject:volumeString];
    [self getPage: [self getXbmcURLForCommand:@"SetVolume" parameters:paramArray] timeout: 3.0];
    [paramArray release];
}

-(void)playNext
{
	[self getPage: [self getXbmcURLForCommand:@"PlayNext"] timeout: 3.0];
}

-(void)playPrev
{
	[self getPage: [self getXbmcURLForCommand:@"PlayPrev"] timeout: 3.0];
}

-(void)pause
{
	[self getPage: [self getXbmcURLForCommand:@"Pause"] timeout: 3.0];
}

-(void)sendCommand:(NSString*)cmd;
{
	[self getPage: [self getXbmcURLForCommand:cmd] timeout: 3.0];
}

-(int)getPlaylistSong
{
	return [self getNumericResponse:[self getPage: [self getXbmcURLForCommand:@"GetPlaylistSong"] timeout: 3.0]];
}

-(void)movePlaylistItem:(int)itemIndex beforeIndex: (int) beforeIndex
{
	NSLog(@"movePlaylistItem");
	NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:2];
	NSString* str = [NSString stringWithFormat:@"%d", itemIndex];
	[paramArray addObject:str];
	str = [NSString stringWithFormat:@"%d", beforeIndex];
	[paramArray addObject:str];
	
	[self getPage: [self getXbmcURLForCommand:@"movePlaylistItem" parameters:paramArray] timeout: 3.0];
	[paramArray release];
}

-(NSString*)getXbmcURLForCommand: (NSString*) cmd
{
   return [NSString stringWithFormat:@"%@%@", [self createURLBase], cmd];
}

-(NSString*)getXbmcURLForCommand: (NSString*) cmd  parameters: (NSArray*) params
{
   NSString* paramString = @"";
   if ([params count] > 0)
   {
      int i;
      NSString* initString = @"&parameter=";
	  for(i=0; i<[params count]; ++i)
	  {
	     //if ([params objectAtIndex:i] == nil) continue;    // don't allow this
	     paramString = [NSString stringWithFormat:@"%@%@%@", paramString, initString, [self encodeURL:[params objectAtIndex: i]]];
		 initString = @";";
	  }
   }
   return [NSString stringWithFormat:@"%@%@%@", [self createURLBase], cmd, paramString];
}




@end

