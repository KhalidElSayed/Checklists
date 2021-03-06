
#import "ListDetailViewController.h"
#import "Checklist.h"

@implementation ListDetailViewController{
    NSString *iconName;
}

@synthesize textField;
@synthesize doneBarButton;
@synthesize delegate;
@synthesize checklistToEdit;
@synthesize iconImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.checklistToEdit != nil){
        self.title = @"Edit Checklist";
        self.textField.text = self.checklistToEdit.name;
        self.doneBarButton.enabled = YES;
        iconName = self.checklistToEdit.iconName;
    }
    self.iconImageView.image = [UIImage imageNamed:iconName];
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setDoneBarButton:nil];
    [self setIconImageView:nil];
    [super viewDidUnload];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self=[super initWithCoder:aDecoder])){
        iconName = @"Folder";
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

-(IBAction)cancel
{
    [self.delegate listDetailViewControllerDidCancel:self];
}

-(IBAction)done
{
    if(self.checklistToEdit == nil){
        Checklist *checklist = [[Checklist alloc] init];
        checklist.name = self.textField.text;
        checklist.iconName  = iconName;
        
        [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
    }else {
        self.checklistToEdit.name = self.textField.text;
        self.checklistToEdit.iconName  = iconName;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1){
        return indexPath;
    }else{
        return nil;
    }
}

-(BOOL) textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length]>0);
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PickIcon"]){
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

-(void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)theIconName
{
    iconName = theIconName;
    self.iconImageView.image = [UIImage imageNamed:iconName];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
