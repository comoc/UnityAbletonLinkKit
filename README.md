# UnityAbletonLinkKit

UnityAbletonLink is an [iOS SDK for Ableton Link](https://github.com/Ableton/LinkKit) plugin for [Unity](https://unity3d.com).

## Clone LinkKit

Clone LinkKit files into the Plugins folder.
```
cd UnityAbletonLinkKit
git submodule update --init --recursive
```

## Writing a Unity application

Create a new Unity project.
Copy the `Plugins` folder into the `Assets` folder of the Unity project.

Where `AbletonLink.cs` is a wrapper script for `UnityAbletonLink` plugin.

Write some script to use this plugin.
For example,

```Example.cs
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Example : MonoBehaviour {

	// Use this for initialization
	void Start () {
        // To activate the connection, user must enable the setting manually.
        AbletonLink.Instance.showLinkSettings();
	}

	// Update is called once per frame
	void Update () {
        double beat, phase, tempo, time;
        int numPeers;
        AbletonLink.Instance.update(out beat, out phase, out tempo, out time, out numPeers);

        // We can obtain the latest beat and phase like this.
        Debug.Log ("beat: " + beat + " phase:" + phase);
	}
}
```

Attach the script to a GameObject (e.g. Main Camera or a GameObject).

Set the target platform iOS, then build the application.

## Difference between UnityAbletonLink and UnityAbletonLinkKit

UnityAbletonLinkKit has the `showLinkSettings()` API to enable user to control the connection to a Link server. Whereas UnityAbletonLink has not.

## License

Excluding LinkKit, licensed under CC0.

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed)
