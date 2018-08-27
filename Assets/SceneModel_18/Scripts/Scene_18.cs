using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scene_18 : MonoBehaviour {

	// Use this for initialization
	public Material material;

	public float speed;

	private float value;

	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if(value>=1.0f){
			value = 0.0f;
		}
		value+=speed*Time.deltaTime;
		material.SetFloat("_ClipAmount",value);
	}
}
