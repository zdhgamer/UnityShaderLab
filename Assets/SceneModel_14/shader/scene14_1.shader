Shader "ZDH/scene14_1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_FlowTex ("Texture", 2D) = "white"{}
		_FlowLight ("FlowLight",Float) = 1
		_Period ("Period(seconds)",Float) = 1//总时间
		_FlowWidth ("FlowWidth",Float) = 0.1//宽度
		_CenterColor("CenterColor",Color) = (1,1,1,1)//中心点的颜色
		_EdgeColor("EdgeColor",Color) = (1,1,1,1)//边缘的的颜色
		
	}
	SubShader
	{
		Tags { 
			"RenderType"="Transparent" 
			"IgnorProjector" = "True" 
			"Queue" = "Transparent"
			}
		LOD 100
		Cull Off
		ZWrite Off
		Blend One One
		Fog {Mode Off }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _FlowTex;
			float4 _FlowTex_ST;
			float4 _MainTex_ST;
			float _FlowLight;
			float _Period;
			float _FlowWidth;
			float4 _CenterColor;
			float4 _EdgeColor;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 fw : TEXCOORD1;
			};


			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.fw = TRANSFORM_TEX(v.uv, _FlowTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				float2 center = float2(0.5,0.5);//uv中心点
				float d = distance(i.uv,center);//当前像素到中心点的距离
				float dmax = 0.5;//离中心点的最大距离
				float speed = (dmax+_FlowWidth)/_Period;//没秒移动的速度
				float progress = fmod(_Time.y,_Period)/_Period;//当前进度//_Time.x是20s，_Time.y是1s
				float nowmaxd = fmod(_Time.y,_Period)*speed;//时间*速度= 路程，就是当前离中心点的距离
				float nowmind = nowmaxd - _FlowWidth;//最大-宽度 = 最小
				float isInFlow = step(nowmind, d) - step(nowmaxd, d);//如果是在宽度的中间，返回1，不然返回0
				float2 flowTexUV = float2((d - nowmind) / (nowmaxd - nowmind), 0);//计算当前像素在flow的位置比例
				float4 nowdcolor = _CenterColor + (_EdgeColor-_CenterColor)*progress;//当前点的颜色
				fixed4 finalColor = col + isInFlow * _FlowLight * col * tex2D(_FlowTex, flowTexUV)*nowdcolor;
				return finalColor;
			}
			ENDCG
		}
	}
}
