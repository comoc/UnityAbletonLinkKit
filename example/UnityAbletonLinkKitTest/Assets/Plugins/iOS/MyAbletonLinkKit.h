#ifndef MyAbletonLinkKit_h
#define MyAbletonLinkKit_h

#include "ABLLink.h"
#include "ABLLinkSettingsViewController.h"

#include <algorithm>
#include <atomic>
#include <chrono>
#include <iostream>
#include <thread>

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(_WIN64) || defined(WINAPI_FAMILY) || defined(__CYGWIN32__)
#define UNITY_INTERFACE_EXPORT __declspec(dllexport)
#define UNITY_INTERFACE_API __stdcall
#else
#define UNITY_INTERFACE_EXPORT
#define UNITY_INTERFACE_API
#endif

//#ifdef __cplusplus
//extern "C" {
//#endif
//    using numPeersCallback = void(UNITY_INTERFACE_API *)(int);
//    using tempoCallback = void(UNITY_INTERFACE_API *)(double);
//#ifdef __cplusplus
//}
//#endif

class MyAbletonLinkKit {
public:
    struct Status
    {
        double beat;
        double phase;
        double tempo;
        double quantam;
        double time;
        int numPeers;
        Status() : beat(0.0), phase(0.0), tempo(0.0), quantam(0.0), time(0.0), numPeers(0) {}
    };
    MyAbletonLinkKit();
    ~MyAbletonLinkKit();
    
    MyAbletonLinkKit(const MyAbletonLinkKit&) = delete;
    MyAbletonLinkKit& operator=(const MyAbletonLinkKit&) = delete;
    MyAbletonLinkKit(MyAbletonLinkKit&&) = delete;
    MyAbletonLinkKit& operator=(MyAbletonLinkKit&&) = delete;
    
    void setup(double bpm);
    
    void setTempo(double bpm);
    double tempo();
    
    void setQuantum(double quantum);
    double quantum();
    
    void forceBeatAtTime(double beat);
    void requestBeatAtTime(double beat);
    
    void enable(bool bEnable);
    bool isEnabled() const;
    
    bool isConnected() const;
    bool isStartStopSyncEnabled() const;
//    std::size_t numPeers();
    
    Status update();
    
    void showLinkSettings();
private:
    ABLLinkRef link_;
    double quantum_;

    bool isNumPeersChanged_;
    int numPeers_;

    bool isTempoChanged_;
    double tempo_;
    
    UIViewController *linkSettings_;
//    numPeersCallback npc;
//    tempoCallback tc;
};


#endif /* MyAbletonLinkKit_h */
