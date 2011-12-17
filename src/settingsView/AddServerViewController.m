#import "AddServerViewController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation AddServerViewController
@synthesize hostName;
@synthesize serverInfo = _serverInfo;
///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithHost:(NSString *)host
{
    self  = [super initWithNibName:nil bundle:nil ];
    if (self) 
    {
        self.tableViewStyle = UITableViewStyleGrouped;
        self.autoresizesForKeyboard = YES;
        self.variableHeightRows = YES;
        
        self.title = @"Add Server";
        
        hostName = [host copy];
        self.serverInfo = [NSMutableDictionary dictionary];
        [_serverInfo setValue:@"9090" forKey:@"tcpport"];
        
        
        UITextField* nameTextField = [[[UITextField alloc] init] autorelease];
        nameTextField.font = TTSTYLEVAR(font);
        nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        nameTextField.textAlignment = UITextAlignmentRight;
        nameTextField.delegate = self;
        nameTextField.placeholder = @"Home";
        nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        nameTextField.tag = 0;
        TTTableControlItem* nameFieldItem = [TTTableControlItem itemWithCaption:@"Name"
                                                                        control:nameTextField];
                
        UITextField* addressTextField = [[[UITextField alloc] init] autorelease];
        addressTextField.font = TTSTYLEVAR(font);
        addressTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        addressTextField.textAlignment = UITextAlignmentRight;
        addressTextField.delegate = self;
        addressTextField.placeholder = @"192.168.1.10";
        addressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        addressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        addressTextField.tag = 1;
        TTTableControlItem* addressFieldItem = [TTTableControlItem itemWithCaption:@"Address"
                                                                           control:addressTextField];
        
        UITextField* loginTextField = [[[UITextField alloc] init] autorelease];
        loginTextField.font = TTSTYLEVAR(font);
        loginTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        loginTextField.textAlignment = UITextAlignmentRight;
        loginTextField.delegate = self;
        loginTextField.placeholder = @"xbmc";
        loginTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        loginTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        loginTextField.tag = 2;
        TTTableControlItem* loginFieldItem = [TTTableControlItem itemWithCaption:@"Username"
                                                                           control:loginTextField];
        
        UITextField* passwordTextField = [[[UITextField alloc] init] autorelease];
        passwordTextField.font = TTSTYLEVAR(font);
        passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passwordTextField.textAlignment = UITextAlignmentRight;
        passwordTextField.delegate = self;
        passwordTextField.placeholder = @"xbmc";
        passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        passwordTextField.tag = 3;
        TTTableControlItem* passwordFieldItem = [TTTableControlItem itemWithCaption:@"Password"
                                                                           control:passwordTextField];
        
        UITextField* portTextField = [[[UITextField alloc] init] autorelease];
        portTextField.font = TTSTYLEVAR(font);
        portTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        portTextField.textAlignment = UITextAlignmentRight;
        portTextField.delegate = self;
        portTextField.placeholder = @"80";
        portTextField.tag = 4;
        TTTableControlItem* portFieldItem = [TTTableControlItem itemWithCaption:@"Port"
                                                                           control:portTextField];
        
        UITextField* tcpportTextField = [[[UITextField alloc] init] autorelease];
        tcpportTextField.font = TTSTYLEVAR(font);
        tcpportTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tcpportTextField.textAlignment = UITextAlignmentRight;
        tcpportTextField.text = [_serverInfo valueForKey:@"tcpport"];
        tcpportTextField.placeholder = [_serverInfo valueForKey:@"tcpport"];
        tcpportTextField.delegate = self;
        tcpportTextField.tag = 5;
        TTTableControlItem* tcpportFieldItem = [TTTableControlItem itemWithCaption:@"TCP Port"
                                                                           control:tcpportTextField];
        self.dataSource = [TTListDataSource dataSourceWithObjects:
                           nameFieldItem,
                           addressFieldItem,
                           loginFieldItem,
                           passwordFieldItem,
                           portFieldItem,
                           tcpportFieldItem,
                           nil];
        
        if (![hostName isEqual:@""])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            serverInfo = ;
            self.serverInfo = [NSMutableDictionary dictionaryWithDictionary:[[defaults objectForKey:@"hosts"] objectForKey:hostName]];
            nameTextField.text = hostName;
            nameTextField.enabled = FALSE;
            addressTextField.text = [_serverInfo objectForKey:@"address"];
            loginTextField.text = [_serverInfo objectForKey:@"login"];
            passwordTextField.text = [_serverInfo objectForKey:@"pwd"];
            portTextField.text = [_serverInfo objectForKey:@"port"];
            tcpportTextField.text = [_serverInfo objectForKey:@"tcpport"];
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [self initWithHost:@""];
    if (self) 
    {
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_serverInfo);
    TT_RELEASE_SAFELY(hostName);
	[super dealloc];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveItem;
    [saveItem release];
}

- (void) save {
    [self findAndResignFirstResonder: self.view];
    if ([hostName compare:@""] == NSOrderedSame ||
        [_serverInfo valueForKey:@"address"] == nil ||
        [_serverInfo valueForKey:@"address"] == @"" ||
        [_serverInfo valueForKey:@"login"] == nil ||
        [_serverInfo valueForKey:@"login"] == @"" ||
        [_serverInfo valueForKey:@"pwd"] == nil ||
        [_serverInfo valueForKey:@"pwd"] == @"" ||
        [_serverInfo valueForKey:@"port"] == nil ||
        [_serverInfo valueForKey:@"port"] == @"" ||
        [_serverInfo valueForKey:@"tcpport"] == nil ||
        [_serverInfo valueForKey:@"tcpport"] == @""          
          )
         {
             UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle: @"Error"
                                   message: @"You need to fill all fields!"
                                   delegate: nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
             [alert show];
             [alert release];
//			 [serverInfo release];
             return;
         }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* hosts;
    if ([defaults objectForKey:@"hosts"] == nil)
    {
        hosts = [[NSMutableDictionary alloc] init];
    }
    else
    {
        hosts =  [[NSMutableDictionary alloc] 
                  initWithDictionary:[defaults objectForKey:@"hosts"]];
    }
    if ([hosts valueForKey:hostName] == nil)
    {
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"hostAdded" 
         object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:hostName, @"name"
                              , [[[NSString alloc] initWithString:[_serverInfo objectForKey:@"address"]] autorelease], @"address"
                              , nil]];	
    }
    else
    {
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"hostUpdated" 
         object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:hostName, @"name"
                              , [[[NSString alloc] initWithString:[_serverInfo objectForKey:@"address"]] autorelease], @"address"
                              , nil]];	
    }
    
//	[serverInfo release];
    [hosts 
        setObject:[NSDictionary dictionaryWithDictionary:_serverInfo] 
     forKey:hostName];
    [defaults setObject:hosts forKey:@"hosts"];
    [defaults setObject:hostName forKey:@"currenthost"];
    
    [defaults synchronize];
    [hosts release];
    
    
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"hostChanged" 
     object:nil];
//    [self dismissModalViewControllerAnimated:YES];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            hostName = [NSString stringWithString:textField.text];
            break;
        case 1:
            [_serverInfo setValue:[NSString stringWithString:textField.text] forKey:@"address"];
            break;
        case 2:
            [_serverInfo setValue:[NSString stringWithString:textField.text] forKey:@"login"];
            break;
        case 3:
            [_serverInfo setValue:[NSString stringWithString:textField.text] forKey:@"pwd"];
            break;
        case 4:
            [_serverInfo setValue:[NSString stringWithString:textField.text] forKey:@"port"];
            break;
        case 5:
            [_serverInfo setValue:[NSString stringWithString:textField.text] forKey:@"tcpport"];
            break;
        default:
            break;
    }   
}

- (BOOL)findAndResignFirstResonder: (UIView*) stView
{
    if (stView.isFirstResponder) {
        [stView resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in stView.subviews) {
        if ([self findAndResignFirstResonder: subView])
            return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
