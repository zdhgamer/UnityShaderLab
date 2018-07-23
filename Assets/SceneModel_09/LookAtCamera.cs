using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAtCamera : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		//一下代码效果一样
		//gameObject.transform.LookAt(Camera.main.transform);
		gameObject.transform.rotation = Camera.main.transform.rotation;
	}
}
