using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneModel_04 : MonoBehaviour {

    public GameObject ui;

    public GameObject cube;

    public Camera UICamera;

	// Use this for initialization
	void Start () {
        //Debug.Log(ui.transform.position);
        //Debug.Log(ui.GetComponent<RectTransform>().position);
        //Debug.Log(UICamera.WorldToScreenPoint(ui.transform.position));
        //Debug.Log(Camera.main.ScreenToWorldPoint(UICamera.WorldToScreenPoint(ui.transform.position)));
        //;
        //cube.transform.Translate(Camera.main.ScreenToWorldPoint(ui.transform.position) - cube.transform.position);
        //cube.transform.position = Camera.main.ScreenToWorldPoint(ui.transform.position);
        //Debug.Log(Camera.main.ScreenToWorldPoint(ui.transform.position));
    }
	
	// Update is called once per frame
	void Update () {
        if (Input.anyKey) {
            Debug.Log(Input.mousePosition);
        }
        
	}
}
