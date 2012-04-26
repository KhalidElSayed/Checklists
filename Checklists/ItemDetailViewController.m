
#import "ItemDetailViewController.h"
#import "ChecklistItem.h"

@implementation ItemDetailViewController{
    NSString *text;
    BOOL shouldRemind;
    NSDate *dueDate;
}
@synthesize textField;
@synthesize doneBarButton;
@synthesize delegate;
@synthesize itemToEdit;
@synthesize switchControl;
@synthesize dueDateLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.itemToEdit != nil){
        self.title = @"Edit Item";
    }
    self.textField.text = text;
    self.switchControl.on = shouldRemind;
    [self updateDoneBarButton];
    [self updateDueDateLabel];
}

-(void)setItemToEdit:(ChecklistItem *)newItem
{
    if(itemToEdit != newItem)
    {
        itemToEdit = newItem;
        text = itemToEdit.text;
        shouldRemind = itemToEdit.shouldRemind;
        dueDate = itemToEdit.dueDate;
    }
}

-(void) updateDueDateLabel{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [formatter stringFromDate:dueDate];
}
-(void) updateDoneBarButton
{
    self.doneBarButton.enabled = ([text length]>0);
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setDoneBarButton:nil];
    [self setSwitchControl:nil];
    [self setDueDateLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)cancel
{
    [self.delegate itemDetailViewControllerDidCancel:self];
}

-(IBAction)done
{
    if(self.itemToEdit == nil){
        ChecklistItem *item = [[ChecklistItem alloc]init];
        item.text = self.textField.text;
        item.checked = NO;
        item.shouldRemind = self.switchControl.on;
        item.dueDate = dueDate;
        [item scheduleNotification];
        
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
    }else{
        self.itemToEdit.text = self.textField.text;        
        self.itemToEdit.shouldRemind = self.switchControl.on;
        self.itemToEdit.dueDate = dueDate;
        [self.itemToEdit scheduleNotification];
        
        [self.delegate itemDetailViewController:self didFinishEditingItem:itemToEdit];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2){
        return indexPath;
    }
    else {
        return nil;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

-(BOOL) textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    text = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self updateDoneBarButton];
    
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)theTextField
{
    text = theTextField.text;
    [self updateDoneBarButton];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PickDate"]){
        DatePickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.date = dueDate;
    }
}

-(void)datePicker:(DatePickerViewController *)picker didPickDate:(NSDate *)date
{
    dueDate = date;
    [self updateDueDateLabel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)datePickerDidCancel:(DatePickerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)switchChanged:(UISwitch *)sender
{
    shouldRemind = sender.on;
}
@end
