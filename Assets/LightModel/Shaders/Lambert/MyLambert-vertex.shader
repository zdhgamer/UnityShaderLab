Shader "ZDHZDH/LIGHTMODEL/MyLambert"
{
	Properties{
		_DiffuseColor("_DiffuseColor",Color) = (1,1,1,1)
	}

	SubShader{
		Tags{
			"Queue"="Geometry"
			"RanderType"="Opaque"
		}
		pass{
			Tags{
				"LightMode"="ForwardBase"
			}

			CGPROGRAM

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			#pragma vertex vert
			#pragma fragment frag

			float4 _DiffuseColor;

			struct v2f{
				float4 pos:SV_POSITION;
				float3 color:COLOR;
			};			

			v2f vert(appdata_full v){
				v2f o;
				//顶点变换
				o.pos = UnityObjectToClipPos(v.vertex);
				//拿到环境光
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//拿到第一个直射光的颜色
				float3 lightColor = _LightColor0.xyz;
				//拿到世界空间下的法线
				float3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
				//拿到世界空间下的光线方向
				float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//计算最终颜色
				o.color = saturate(dot(worldNormal,worldLightDir))*lightColor*_DiffuseColor;
				return o;
			}

			fixed3 frag(v2f i):SV_TARGET{
				return i.color;
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
