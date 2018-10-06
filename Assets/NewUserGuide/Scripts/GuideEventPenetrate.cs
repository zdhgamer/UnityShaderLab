using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GuideEventPenetrate : MonoBehaviour,ICanvasRaycastFilter {

    private Image target;

    public void SetTargetImage(Image target) {
        this.target = target;
    }

    public bool IsRaycastLocationValid(Vector2 sp, Camera eventCamera)
    {
        if (target == null) {
            return true;
        }

        return !RectTransformUtility.RectangleContainsScreenPoint(target.rectTransform, sp, eventCamera);
    }

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
