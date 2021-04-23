#include "MyAbletonLinkKit.h"
#include <algorithm>
#include <cmath>
#include <chrono>

#include <mach/mach_time.h>

#import "UnityAppController.h"

using namespace std;

MyAbletonLinkKit::MyAbletonLinkKit()
    : link_(nullptr),
    quantum_(4.0),
    isNumPeersChanged_(false),
    numPeers_(0),
    isTempoChanged_(false),
    tempo_(0.0),
    linkSettings_(nil)
{
}

MyAbletonLinkKit::~MyAbletonLinkKit(){
    if(link_ != nullptr){
        ABLLinkSetActive(link_, false);
        ABLLinkDelete(link_);
    }
}

void MyAbletonLinkKit::setup(double tempo){
    if(link_ != nullptr){
        ABLLinkSetActive(link_, false);
        ABLLinkDelete(link_);
    }
    link_ = ABLLinkNew(tempo);
#if 0
    link_->setNumPeersCallback([this](std::size_t peers){
		isNumPeersChanged_ = true;
		numPeers_ = static_cast<int>(peers);
    });
#endif
    
    ABLLinkSetStartStopCallback(link_, [](bool isPlaying, void *context) {
//        MyAbletonLinkKit* that = static_cast<MyAbletonLinkKit*>(context);

    }, this);
    ABLLinkSetIsConnectedCallback(link_, [](bool isConnected, void *context) {
//        MyAbletonLinkKit* that = static_cast<MyAbletonLinkKit*>(context);

    }, this);
    ABLLinkSetSessionTempoCallback(link_, [](double sessionTempo, void* context){
        MyAbletonLinkKit* that = static_cast<MyAbletonLinkKit*>(context);
        that->isTempoChanged_ = true;
        that->tempo_ = sessionTempo;
    }, this);
    ABLLinkSetActive(link_, true);
    
    auto state = ABLLinkCaptureAppSessionState(link_);
    const auto time = mach_absolute_time();
    ABLLinkSetIsPlaying(state, true, time);
    ABLLinkCommitAppSessionState(link_, state);
}

void MyAbletonLinkKit::setTempo(double bpm){
    if (link_ == nullptr){
        return;
    }
    auto state = ABLLinkCaptureAppSessionState(link_);
    const auto time = mach_absolute_time();
    ABLLinkSetTempo(state, bpm, time);
    ABLLinkCommitAppSessionState(link_, state);
}

double MyAbletonLinkKit::tempo(){
    if(link_ == nullptr){
        return 0.0;
    }
    auto state = ABLLinkCaptureAppSessionState(link_);
    return ABLLinkGetTempo(state);
}

void MyAbletonLinkKit::setQuantum(double quantum){
    this->quantum_ = fmin(fmax(quantum, 2.0), 16.0);
}

double MyAbletonLinkKit::quantum(){
    return quantum_;
}

void MyAbletonLinkKit::forceBeatAtTime(double beat) {
    if(link_ == nullptr){
        return;
    }
    auto state = ABLLinkCaptureAppSessionState(link_);
    const auto time = mach_absolute_time();
    ABLLinkForceBeatAtTime(state, beat, time, quantum_);
    ABLLinkCommitAppSessionState(link_, state);
}

void MyAbletonLinkKit::requestBeatAtTime(double beat) {
    if(link_ == nullptr){
        return;
    }
    auto state = ABLLinkCaptureAppSessionState(link_);
    const auto time = mach_absolute_time();
    ABLLinkRequestBeatAtTime(state, beat, time, quantum_);
    ABLLinkCommitAppSessionState(link_, state);
}

void MyAbletonLinkKit::enable(bool bEnable){
    if(link_ == nullptr){
        return;
    }
    ABLLinkSetActive(link_, bEnable);
}

bool MyAbletonLinkKit::isEnabled() const{
    if(link_ == nullptr){
        return false;
    }
    return ABLLinkIsEnabled(link_);
}

bool MyAbletonLinkKit::isConnected() const{
    if(link_ == nullptr){
        return false;
    }
    return ABLLinkIsConnected(link_);
}

bool MyAbletonLinkKit::isStartStopSyncEnabled() const{
    if(link_ == nullptr){
        return false;
    }
    return ABLLinkIsStartStopSyncEnabled(link_);
}

//std::size_t MyAbletonLinkKit::numPeers(){
//    if(link_ == nullptr){
//        return 0;
//    }
//    return 0; // Not supported
//}

MyAbletonLinkKit::Status MyAbletonLinkKit::update(){
    Status status;
    if(link_ == nullptr){
        return status;
    }
    
    auto state = ABLLinkCaptureAppSessionState(link_);
    const auto time = mach_absolute_time();
    
    status.beat  = ABLLinkBeatAtTime(state, time, quantum_);
    status.phase = ABLLinkPhaseAtTime(state, time, quantum_);
    status.quantam = quantum_;
    status.tempo = ABLLinkGetTempo(state);
    status.time = mach_absolute_time() / 1000;
    status.numPeers = 0; // Not supported 
    return status;
}

void MyAbletonLinkKit::showLinkSettings(){
    if(link_ == nullptr){
        return;
    }
    
    if (linkSettings_ == nil)
        linkSettings_ = [ABLLinkSettingsViewController instance:link_];
    UIViewController *unityGLViewController = UnityGetGLViewController();

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:linkSettings_];
    linkSettings_.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:unityGLViewController action:@selector(dismissModalViewControllerAnimated:)];
    
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [unityGLViewController presentViewController:navController animated:YES completion:nil];
}

#if 0
- (IBAction)showLinkSettings:(UIButton *)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_linkSettings];
    // this will present a view controller as a popover in iPad and a modal VC on iPhone
    _linkSettings.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(hideLinkSettings:)];
    
    navController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popC = navController.popoverPresentationController;
    popC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popC.sourceRect = sender.frame;
    
    // we recommend using a size of 320x400 for the display in a popover
    _linkSettings.preferredContentSize = CGSizeMake(320., 400.);
    
    UIButton *button = (UIButton *)sender;
    popC.sourceView = button.superview;
    
    popC.backgroundColor = [UIColor whiteColor];
    _linkSettings.view.backgroundColor = [UIColor whiteColor];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)hideLinkSettings:(id)sender {
#pragma unused(sender)
    [self dismissViewControllerAnimated:YES completion:nil];
}
#endif
