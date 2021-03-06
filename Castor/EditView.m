//
//  EditView.m
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import "EditView.h"

@interface EditView (Private)
- (UIImage *)_scaleImage:(UIImage *)image;
- (void)_disableOperation;
- (void)_enableOperation;
@end

@implementation EditView

@synthesize textView = _textView;
@synthesize letterCount = _letterCount;
@synthesize cameraButton = _cameraButton;
@synthesize postButton = _postButton;
@synthesize clipIcon = _clipIcon;
@synthesize roomId = _roomId;
@synthesize parentId = _parentId;
@synthesize targetEntry = _targetEntry;
@synthesize cameraController = _cameraController;
@synthesize attachmentImage = _attachmentImage;
@synthesize previousView = _previousView;

static const int MAX_LETTER = 280;
static const int MAX_RESOLUTION = 800;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
               roomId:(NSNumber *)roomId 
             parentId:(NSNumber *)parentId 
          targetEntry:(EntryData *)targetEntry 
         previousView:(UIViewController <Reloadable> *)previousView 
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil factory:factory];
    if (self) {
        self.roomId = roomId;
        self.parentId = parentId;
        self.targetEntry = targetEntry;
        self.previousView = previousView;
    }
    return self;
}

- (void)dealloc
{
    self.textView = nil;
    self.letterCount = nil;
    self.cameraButton = nil;
    self.clipIcon = nil;
    self.roomId = nil;
    self.parentId = nil;
    self.targetEntry = nil;
    self.cameraController = nil;
    self.attachmentImage = nil;
    self.previousView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"EditView Will appear");
    if (self.factory != nil) {
        [self _enableOperation];
        
        if (self.parentId != nil) {
            [self.cameraButton setEnabled:NO];
        }
        [self.clipIcon setHidden:YES];
        if (self.factory != nil) {
            if (self.targetEntry == nil) {
                self.title = @"Add Entry";
                self.letterCount.text = [NSString stringWithFormat:@"%d", MAX_LETTER];
            }
            else {
                self.title = @"Update Entry";
                self.textView.text = self.targetEntry.content;
                self.letterCount.text = [NSString stringWithFormat:@"%d", MAX_LETTER - [self.targetEntry.content length]];
            }
            [self.textView becomeFirstResponder];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"EditView loaded");

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textView = nil;
    self.letterCount = nil;
    self.cameraButton = nil;
    self.clipIcon = nil;
    self.roomId = nil;
    self.parentId = nil;
    self.targetEntry = nil;
    self.cameraController = nil;
    self.attachmentImage = nil;
    self.previousView = nil;
}

//// UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int textcount = MAX_LETTER - ([textView.text length] + [text length] - range.length);
    if (textcount < 0) {
        self.letterCount.textColor=[UIColor redColor];
    }else{
        self.letterCount.textColor=[UIColor blackColor];
    }
    self.letterCount.text = [NSString stringWithFormat:@"%d", textcount];
    return YES;
}

//// UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.attachmentImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [self.clipIcon setHidden:NO];
    self.cameraController = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    self.cameraController = nil;
}

//// IBAction
- (IBAction)postEntry:(id)sender
{
    if ([self.textView.text length] > MAX_LETTER) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setDelegate:self];
        [alert setMessage:[NSString stringWithFormat:@"%d文字を越えています", MAX_LETTER]];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        [alert release];
        return;
    }
    else {
        [self _disableOperation];
        [self.textView resignFirstResponder];
        [self performSelector:@selector(_startIndicator:) withObject:self];
        [self performSelectorInBackground:@selector(_postEntryInBackground:) withObject:nil];
    }
}

- (IBAction)openCameraView:(id)sender
{
    NSLog(@"openCameraView");
    [self.textView resignFirstResponder];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"カメラ利用不可"
                                                        message:@"このデバイスではカメラは利用できません"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    self.cameraController = [[[UIImagePickerController alloc] init] autorelease];
    self.cameraController.sourceType = sourceType;
    self.cameraController.delegate = self;
    self.cameraController.allowsEditing = NO;
    [self presentModalViewController:self.cameraController animated:YES];
}

//// Private
- (void)_postEntryInBackground:(id)arg
{
    NSLog(@"post entry In Background");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if (self.targetEntry == nil) {
        NSLog(@"add entry (parentId[%@])", self.parentId);
        if (self.attachmentImage != nil) {
            NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [outputFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *filename = [NSString stringWithFormat:@"%@.png", [outputFormatter stringFromDate:[NSDate date]]];
            [self.factory addEntryText:self.textView.text 
                                 image:UIImagePNGRepresentation([self _scaleImage:self.attachmentImage]) 
                              filename:filename 
                                roomId:self.roomId 
                              parentId:self.parentId 
                                sender:self];
        }
        else {
            [self.factory addEntryText:self.textView.text roomId:self.roomId parentId:self.parentId sender:self];
        }
        [self.previousView reload:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        NSLog(@"edit entry (entryId[%@])", self.targetEntry.entryId);
        [self.factory updateEntryText:self.textView.text roomId:self.roomId entryId:self.targetEntry.entryId sender:self];
        [self.previousView reload:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indicator stopAnimating];
    [pool release];
}

- (UIImage *)_scaleImage:(UIImage *)image
{	
	CGImageRef imgRef = image.CGImage;
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > MAX_RESOLUTION || height > MAX_RESOLUTION) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = MAX_RESOLUTION;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = MAX_RESOLUTION;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

- (void)_disableOperation
{
    [self.textView setEditable:NO];
    [self.cameraButton setEnabled:NO];
    [self.postButton setEnabled:NO];
}

- (void)_enableOperation
{
    [self.textView setEditable:YES];
    [self.cameraButton setEnabled:YES];
    [self.postButton setEnabled:YES];
}

@end
