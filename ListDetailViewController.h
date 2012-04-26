
#import <UIKit/UIKit.h>
#import "IconPickerViewController.h"
@class ListDetailViewController;
@class Checklist;

@protocol ListDetailViewControllerDelegate <NSObject>

-(void) listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
-(void) listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)item;
-(void) listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)item;

@end

@interface ListDetailViewController : UITableViewController <UITextFieldDelegate, IconPickerViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic, weak) id <ListDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) Checklist *checklistToEdit;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

-(IBAction)cancel;
-(IBAction)done;

@end