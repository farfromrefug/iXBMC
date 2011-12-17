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

@class MediaItemFactory;

@interface XBMCHttpInterface : NSObject{
    NSString* _fulladdress;
}
@property (nonatomic,retain) NSString* fulladdress;
+ (XBMCHttpInterface *) sharedInstance;

-(id)init;
- (void) setAddress:(NSString*)address port:(NSString*)port login:(NSString*)log password:(NSString*)pwd;

// XBMC commands
-(BOOL)checkOnline;
-(void)playFile: (NSString*) path;
-(void)queueFile: (NSString*) path;
-(NSMutableDictionary*)getFileInfo: (NSString*)path;
-(NSMutableDictionary*)getCurrentlyPlayingInfo;
-(int)getCurrentPlaylistIndex;
-(void)setCurrentPlaylistIndex:(int)index;
-(BOOL)isSomethingPlaying;
-(void)setPlaylistSong:(int)index;
-(void)stop;

-(float)getVolume;
-(void)setVolume:(float)volume;
-(void)playNext;
-(void)playPrev;
-(void)pause;
-(void)sendCommand:(NSString*)cmd;

-(int)getPlaylistSong;
-(void)movePlaylistItem:(int)itemIndex beforeIndex: (int) beforeIndex;


-(NSString*)getXbmcURLForCommand: (NSString*) cmd;
-(NSString*)getXbmcURLForCommand: (NSString*) cmd  parameters: (NSArray*) params;

-(NSData*)getXBMCFile: (NSString*) url;
-(UIImage*)getImageFromSpecial: (NSString*) url;
+(NSString*)getUrlFromSpecial: (NSString*) url;

// private
-(NSString*)XbmcIPAddress;
-(BOOL)isNumeric:(NSString*)str;
-(int)getLines: (NSString*) text lines: (NSMutableArray*)theLines;
-(NSString*) getPage: (NSString*) urlString timeout: (double) timeoutVal;

@end


