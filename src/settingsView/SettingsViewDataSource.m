
#import "SettingsViewDataSource.h"
#import "HostTableItem.h"
#import "HostTableItemCell.h"

// Three20 Additions
#import <Three20Core/NSDateAdditions.h>


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SettingsViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
  if (self = [super init]) 
  {
    _model = [[TTModel alloc] init];
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {

  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
  return _model;
}

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[HostTableItem class]]) 
    {
        return [HostTableItemCell class];
    }
    else
    {
        return [super tableView:tableView cellClassForObject:object];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0
        && [[NSUserDefaults standardUserDefaults] objectForKey:@"hosts"] != nil
        && indexPath.row < [[[NSUserDefaults standardUserDefaults] objectForKey:@"hosts"] count])
    return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id object = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [(TTModel*)self.model didDeleteObject:object atIndexPath:indexPath];
                
        
        
        //[self.model didDeleteObject:object atIndexPath:indexPath];
    }
}

- (NSIndexPath*) tableView:(UITableView *)tableView willRemoveObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"askToDeleteHost" 
     object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[(HostTableItem*)object text], @"name", nil]];

    
    // removeItemAtIndexPath returns YES if the section is removed
    if ([self removeItemAtIndexPath:indexPath andSectionIfEmpty:YES]) {
        // remove an index path only to that section
        return [NSIndexPath indexPathWithIndex:indexPath.section];
    } else {
        return indexPath;
    }
}

- (NSIndexPath*)tableView:(UITableView*)tableView willInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    return [self tableView:tableView indexPathForObject:object]; 
}

@end

