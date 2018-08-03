Shader "ZDH/Billboard" {
	Properties {
		_MainTex ("Main Tex", 2D) = "white" {}
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		//1是固定法线向观察者方向（永远正向观察者,比如粒子） 
		//0是固定指向的方向是（0,1，0）(指向方向永远不变，比如草)
		_VerticalBillboarding ("Vertical Restraints", Range(0, 1)) = 1 
	}
	SubShader {
		Tags {
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"DisableBatching"="True"
			}
		
		Pass { 
			Tags { "LightMode"="ForwardBase" }
			
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off
		
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			fixed _VerticalBillboarding;
			
			struct a2v {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			v2f vert (a2v v) {
				v2f o;
				//采用的是右手法则
				// 选择模型空间的原点作为锚点
				float3 center = float3(0, 0, 0);
				//取得模型空间下得视角方向
				float3 viewer = mul(unity_WorldToObject,float4(_WorldSpaceCameraPos, 1));
				//取得目标法线方向
				float3 normalDir = viewer - center;
				//1是固定法线向观察者方向（永远正向观察者,比如粒子） 
				//0是固定指向的方向是（0,1，0）(指向方向永远不变，比如草),那么它的法线方向的y就要为0，因为要垂直
				normalDir.y =normalDir.y * _VerticalBillboarding;
				normalDir = normalize(normalDir);
				//根据法线方向，粗劣拿到向上的方向，用于计算向右的方向
				float3 upDir = abs(normalDir.y) > 0.999 ? float3(0, 0, 1) : float3(0, 1, 0);
				float3 rightDir = normalize(cross(upDir, normalDir));
				//用法线和向右计算向上
				upDir = normalize(cross(normalDir, rightDir));
				
				// 旋转顶点
				float3 centerOffs = v.vertex.xyz - center;
				float3 localPos = center + rightDir * centerOffs.x + upDir * centerOffs.y + normalDir * centerOffs.z;
              
				o.pos = UnityObjectToClipPos(float4(localPos, 1));
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				fixed4 c = tex2D (_MainTex, i.uv);
				c.rgb *= _Color.rgb;
				
				return c;
			}
			
			ENDCG
		}
	} 
	FallBack "Transparent/VertexLit"
}
