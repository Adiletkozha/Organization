//
// Copyright (c) 2015 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

#import "SelectSingleView.h"
#import "SelectMultipleView.h"
#import "AddressBookView.h"
#import "FacebookFriendsView.h"
#import "M13InfiniteTabBarController.h"
#import "ChatView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@class M13InfiniteTabBarController;

@interface RecentView : UITableViewController <UIActionSheetDelegate, SelectSingleDelegate, SelectMultipleDelegate, AddressBookDelegate, FacebookFriendsDelegate,UINavigationControllerDelegate>
//-------------------------------------------------------------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbar;
@property (nonatomic, strong) M13InfiniteTabBarController *infiniteTabBarController;
@property (nonatomic,strong) ChatView *ch1;
- (void)loadRecents;

@end
