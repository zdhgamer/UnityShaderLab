using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CircleGuide : MonoBehaviour {

    /// <summary>
    /// 需要高亮的目标
    /// </summary>
	public Image target;

    /// <summary>
    /// 区域范围缓存
    /// </summary>
	private Vector3[]  corners = new Vector3[4];

    /// <summary>
    /// 圆心
    /// </summary>
    private Vector4 center;

    /// <summary>
    /// 半径
    /// </summary>
    private float radius;

    /// <summary>
    /// 材质
    /// </summary>
    private Material material;

    /// <summary>
    /// 当前 半径
    /// </summary>
    private float currentRadius;

    /// <summary>
    /// 动画时间
    /// </summary>
    private float shrinkTime=0.5f;

    /// <summary>
    /// 动画的速度
    /// </summary>
    private float shrinkVelocity;

    /// <summary>
    /// 新手引导事件
    /// </summary>
    private GuideEventPenetrate guideEventPenetrate;

    private void Awake()
    {
        guideEventPenetrate = GetComponentInChildren<GuideEventPenetrate>();
        if (guideEventPenetrate != null)
        {
            guideEventPenetrate.SetTargetImage(target);
        }
        Canvas canvas = GameObject.Find("Canvas").GetComponent<Canvas>();
        //获取高亮区域 的四个顶点的世界坐标
        target.rectTransform.GetWorldCorners(corners);
        //计算最终显示高亮显示区域的半径
        radius = Vector2.Distance(WorldToCanvas(canvas, corners[0]), WorldToCanvas(canvas, corners[2])) / 2.0f;
        //计算高亮显示区域的原型 0是左下角 1是左上角 2是右上角 3是右下角
        float x = (corners[0].x + corners[3].x) / 2.0f;
        float y = (corners[0].y + corners[1].y) / 2.0f;
        Vector3 centerWorldPos = new Vector3(x, y, 0);
        Vector2 centerCanvsPos = WorldToCanvas(canvas, centerWorldPos);
        //设置材质的圆心变量
        Vector4 centerMat = new Vector4(centerCanvsPos.x, centerCanvsPos.y, 0, 0);
        material = GetComponent<Image>().material;
        material.SetVector("_Center", centerMat);
        //计算当前显示高亮区域的半径
        RectTransform canvasRectTransform = canvas.transform as RectTransform;
        if (canvasRectTransform != null) {
            //获取画布的四个 世界坐标顶点
            canvasRectTransform.GetWorldCorners(corners);
            //计算高亮区域的初始半径
            for (int i=0;i< corners.Length;i++) {
                currentRadius = Mathf.Max(Vector3.Distance(WorldToCanvas(canvas, corners[i]), centerCanvsPos), currentRadius);
            }
        }
        material.SetFloat("_Slider", currentRadius);
    }

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

        float value = Mathf.SmoothDamp(currentRadius, radius, ref shrinkVelocity, shrinkTime);
        if (!Mathf.Approximately(value, currentRadius))
        {
            currentRadius = value;
            material.SetFloat("_Slider", currentRadius);
        }
    }

    /// <summary>
    /// 世界坐标转到canvas坐标
    /// </summary>
    /// <param name="canvas">画布</param>
    /// <param name="worldPos">世界坐标</param>
    /// <returns></returns>
    private Vector2 WorldToCanvas(Canvas canvas,Vector3 worldPos) {
        Vector2 position = Vector2.zero;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(canvas.transform as RectTransform, worldPos, null, out position);
        return position;
    }
}
