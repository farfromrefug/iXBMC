//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TVShowsViewModel.h"

//#import <extThree20JSON/extThree20JSON.h>

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TVShowsViewModel




///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCategory:(NSString*)category {
  if (self = [super init]) {
//    self.category = category;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {

    [super dealloc];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
//  if (!self.isLoading && TTIsStringWithAnyText(_searchQuery)) {
//    NSString* url = [NSString stringWithFormat:kFacebookSearchFeedFormat, _searchQuery];
//
//    TTURLRequest* request = [TTURLRequest
//                             requestWithURL: url
//                             delegate: self];
//
//    request.cachePolicy = cachePolicy | TTURLRequestCachePolicyEtag;
//    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
//
//    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
//    request.response = response;
//    TT_RELEASE_SAFELY(response);
//
//    [request send];
//  }
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)requestDidFinishLoad:(TTURLRequest*)request {
//  TTURLJSONResponse* response = request.response;
//  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
//
//  NSDictionary* feed = response.rootObject;
//  TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);
//
//  NSArray* entries = [feed objectForKey:@"data"];
//
//  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//  [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
//  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
//
//  TT_RELEASE_SAFELY(_posts);
//  NSMutableArray* posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
//
//  for (NSDictionary* entry in entries) {
//    TTFacebookPost* post = [[TTFacebookPost alloc] init];
//
//    NSDate* date = [dateFormatter dateFromString:[entry objectForKey:@"created_time"]];
//    post.created = date;
//    post.postId = [NSNumber numberWithLongLong:
//                     [[entry objectForKey:@"id"] longLongValue]];
//    post.text = [entry objectForKey:@"message"];
//    post.name = [[entry objectForKey:@"from"] objectForKey:@"name"];
//
//    [posts addObject:post];
//    TT_RELEASE_SAFELY(post);
//  }
//  _posts = posts;
//
//  TT_RELEASE_SAFELY(dateFormatter);
//
//  [super requestDidFinishLoad:request];
//}


@end

