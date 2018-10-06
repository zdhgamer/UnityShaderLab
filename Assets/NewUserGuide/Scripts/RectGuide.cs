using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RectGuide : MonoBehaviour {

    /// <summary>
    /// 高亮显示的目标
    /// </summary>
    public Image target;

    /// <summary>
    /// 高亮区域的缓存
    /// </summary>
    private Vector3[] corners = new Vector3[4];

    /// <summary>
    /// 矩形中心
    /// </summary>
    private Vector4 center;

    /// <summary>
    /// 最终的偏移值x
    /// </summary>
    private float targetOffsetX = 0.0f;

    /// <summary>
    /// 最终的偏移值y
    /// </summary>
    private float targetOffsetY = 0.0f;

    /// <summary>
    /// 材质
    /// </summary>
    private Material material;

    /// <summary>
    /// 当前偏移值X
    /// </summary>
    private float currentOffsetX = 0.0f;

    /// <summary>
    /// 当前偏移值y
    /// </summary>
    private float currentOffsetY = 0.0f;

    /// <summary>
    /// 动画 时间
    /// </summary>
    private float shrinkTime = 0.5f;

    /// <summary>
    /// 动画的速度X
    /// </summary>
    private float shrinkVelocityX = 0.0f;

    /// <summary>
    /// 动画的速度Y
    /// </summary>
    private float shrinkVelocityY = 0.0f;

    /// <summary>
    /// 新手引导事件
    /// </summary>
    private GuideEventPenetrate guideEventPenetrate;

    private void Awake()
    {
        guideEventPenetrate = GetComponentInChildren<GuideEventPenetrate>();
        if (guideEventPenetrate!=null) {
            guideEventPenetrate.SetTargetImage(target);
        }
        Canvas canvas = GameObject.Find("Canvas").GetComponent<Canvas>();
        //获取高亮区域 的四个顶点的世界坐标
        target.rectTransform.GetWorldCorners(corners);
        //计算高亮显示区域在画布中的范围  0是左下角 1是左上角 2是右上角 3是右下角
        targetOffsetX = Vector2.Distance(WorldToCanvas(canvas, corners[0]), WorldToCanvas(canvas, corners[3])) / 2;
        targetOffsetY = Vector2.Distance(WorldToCanvas(canvas, corners[0]), WorldToCanvas(canvas, corners[1])) / 2;
        //计算显示的中心
        float x = corners[0].x + ((corners[3].x - corners[0].x)) / 2;
        float y = corners[0].y + ((corners[1].y - corners[0].y)) / 2;
        Vector3 centerWorldPos = new Vector3(x, y, 0);
        Vector2 centerCanvsPos = WorldToCanvas(canvas, centerWorldPos);
        //设置遮罩材料中心变量
        Vector4 centerMat = new Vector4(centerCanvsPos.x, centerCanvsPos.y, 0, 0);
        material = GetComponent<Image>().material;
        material.SetVector("_Center", centerMat);
        //计算当前的偏移
        RectTransform canvasRectTransform = canvas.transform as RectTransform;
        if (canvasRectTransform!=null) {
            //获取画布的四个 世界坐标顶点
            canvasRectTransform.GetWorldCorners(corners);
            //计算初始值
            for (int i = 0; i < corners.Length; i++)
            {
                if (i % 2 == 0)
                {
                    currentOffsetX = Mathf.Max(Vector3.Distance(WorldToCanvas(canvas, corners[i]), centerCanvsPos), currentOffsetX);
                }
                else {
                    currentOffsetY = Mathf.Max(Vector3.Distance(WorldToCanvas(canvas, corners[i]), centerCanvsPos), currentOffsetY);
                }
            }
        }
        //设置当前的偏移量
        material.SetFloat("_SliderX", currentOffsetX);
        material.SetFloat("_SliderY", currentOffsetY);
    }

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        //从当前 偏移到目标偏移
        float valueX = Mathf.SmoothDamp(currentOffsetX, targetOffsetX, ref shrinkVelocityX, shrinkTime);
        float valueY = Mathf.SmoothDamp(currentOffsetY, targetOffsetY, ref shrinkVelocityY, shrinkTime);
        if (!Mathf.Approximately(valueX, currentOffsetX)) {
            currentOffsetX = valueX;
            material.SetFloat("_SliderX", currentOffsetX);
        }
        if (!Mathf.Approximately(valueY, currentOffsetY)) {
            currentOffsetY = valueY;
            material.SetFloat("_SliderY", currentOffsetY);
        }

    }

    /// <summary>
    /// 世界坐标转到canvas坐标
    /// </summary>
    /// <param name="canvas">画布</param>
    /// <param name="worldPos">世界坐标</param>
    /// <returns></returns>
    private Vector2 WorldToCanvas(Canvas canvas, Vector3 worldPos)
    {
        Vector2 position = Vector2.zero;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(canvas.transform as RectTransform, worldPos, null, out position);
        return position;
    }

}
