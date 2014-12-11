![PBJVision](https://raw.github.com/piemonte/PBJVision/master/pbj.gif)

## PBJVision

`PBJVision` is an iOS camera engine library that supports touch-to-record video, slow motion video (120 fps on [supported hardware](https://www.apple.com/iphone/compare/)), and photo capture.

The library also supports features such as onion skinning (ghosting), flash/torch usage, white balance adjustment, focus adjustment, exposure adjustment, and mirroring. Pause and resume video capture is also possible without having to use the touch-to-record gesture interaction as the sample project provides.

I created this library at [DIY](http://diy.org) as a fun means for young people to author video and share their skills. The touch-to-record interaction was originally pioneered by [Vine](http://vine.co) and also adopted by [Instagram](http://instagram.com). Thanks to everyone who has contributed and helped make this a fun project and community.

If you need a video player, check out [PBJVideoPlayer (obj-c)](https://github.com/piemonte/PBJVideoPlayer) and [Player (Swift)](https://github.com/piemonte/player).

Please review the [release history](https://github.com/piemonte/PBJVision/releases) for a summary of the latest changes and more information.

Contributions are welcome!

[![Build Status](https://travis-ci.org/piemonte/PBJVision.svg?branch=master)](https://travis-ci.org/piemonte/PBJVision)

## Installation

[CocoaPods](http://cocoapods.org) is the recommended method of installing PBJVision, just add the following line to your `Podfile`:

```ruby
pod 'PBJVision'
```

## Usage

Import the header.

```objective-c
#import "PBJVision.h"
```

Setup the camera preview using `[[PBJVision sharedInstance] previewLayer]`.

```objective-c
    // preview and AV layer
    _previewView = [[UIView alloc] initWithFrame:CGRectZero];
    _previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 60.0f, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
    _previewView.frame = previewFrame;
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
```

Setup and configure the `PBJVision` controller, then start the camera preview.

```objective-c
- (void)_setup
{
    _longPressGestureRecognizer.enabled = YES;

    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    vision.cameraMode = PBJCameraModeVideo;
    vision.cameraOrientation = PBJCameraOrientationPortrait;
    vision.focusMode = PBJFocusModeContinuousAutoFocus;
    vision.outputFormat = PBJOutputFormatSquare;

    [vision startPreview];
}
```

Start/pause/resume recording.

```objective-c
- (void)_handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
      case UIGestureRecognizerStateBegan:
        {
            if (!_recording)
                [[PBJVision sharedInstance] startVideoCapture];
            else
                [[PBJVision sharedInstance] resumeVideoCapture];
            break;
        }
      case UIGestureRecognizerStateEnded:
      case UIGestureRecognizerStateCancelled:
      case UIGestureRecognizerStateFailed:
        {
            [[PBJVision sharedInstance] pauseVideoCapture];
            break;
        }
      default:
        break;
    }
}
```

End recording.

```objective-c
    [[PBJVision sharedInstance] endVideoCapture];
```

Handle the final video output or error accordingly.

```objective-c
- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{   
    if (error && [error.domain isEqual:PBJVisionErrorDomain] && error.code == PBJVisionErrorCancelled) {
        NSLog(@"recording session cancelled");
        return;
    } else if (error) {
        NSLog(@"encounted an error in video capture (%@)", error);
        return;
    }

    _currentVideo = videoDict;
    
    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    [_assetLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Video Saved!" message: @"Saved to the camera roll."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }];
}
```

To adjust the video quality and compression bit rate, modify the following properties on the `PBJVision` controller.

```objective-c
    @property (nonatomic, copy) NSString *captureSessionPreset;

    @property (nonatomic) CGFloat videoBitRate;
    @property (nonatomic) NSInteger audioBitRate;
    @property (nonatomic) NSDictionary *additionalCompressionProperties;
```

## Community

- Need help? Use [Stack Overflow](http://stackoverflow.com/questions/tagged/pbjvision) with the tag 'pbjvision'.
- Questions? Use [Stack Overflow](http://stackoverflow.com/questions/tagged/pbjvision) with the tag 'pbjvision'.
- Found a bug? Open an [issue](https://github.com/piemonte/PBJVision/issues).
- Feature idea? Open an [issue](https://github.com/piemonte/PBJVision/issues).
- Want to contribute? Submit a [pull request](https://github.com/piemonte/PBJVision/blob/master/CONTRIBUTING.md).

## Resources

* [AV Foundation Programming Guide](https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/00_Introduction.html)
* [PBJVideoPlayer, a simple iOS video player in Objective-C](https://github.com/piemonte/PBJVideoPlayer)
* [Player, a simple iOS video player in Swift](https://github.com/piemonte/player)

## License

PBJVision is available under the MIT license, see the [LICENSE](https://github.com/piemonte/PBJVision/blob/master/LICENSE) file for more information.
