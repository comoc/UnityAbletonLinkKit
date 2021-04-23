using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent (typeof (Text))]
public class LinkInfo : MonoBehaviour {

	// Use this for initialization
	void Start () {
#if UNITY_IOS
		// IMPORTANT! To activate the connection, user must enable the setting manually.
		AbletonLink.Instance.showLinkSettings();
#endif
		//var numPeersPtr = System.Runtime.InteropServices.Marshal.GetFunctionPointerForDelegate(new AbletonLink.NumPeersCallbackDelegate(numPeers));
		//AbletonLink.Instance.setNumPeersCallback(numPeersPtr);
		//var tempoPtr = System.Runtime.InteropServices.Marshal.GetFunctionPointerForDelegate(new AbletonLink.TempoCallbackDelegate(tempo));
		//AbletonLink.Instance.setTempoCallback(tempoPtr);
	}

	// Update is called once per frame
	void Update () {
		double beat, phase, tempo, time;
		int numPeers;
		AbletonLink.Instance.update(out beat, out phase, out tempo, out time, out numPeers);
		double quantum = AbletonLink.Instance.quantum();
		GetComponent<Text> ().text = "Tempo:" + tempo + " Quantum:" + quantum + "\n"
			+ "Beat:" + beat + " Phase:" + phase + "\n"
			+ "NumPeers:" + numPeers;
	}
}
