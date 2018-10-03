Shader"ZDHZDH/LightModel/Specular-vertex"{
	Properties{
		_DiffuseColor("_DiffuseColor",Color)=(1,1,1,1)
		_SpecularColor("_SpecularColor",Color)=(1,1,1,1)
		_Gloss("_Gloss",Range(8,255))=20
	}

	SubShader{
		Tags{
			"Queue"="Geometry"
			"RenderType"="Opaque"
		}
		pass{
			Tags{
				"LightMode"="ForwardBase"
			}
			CGPROGRAM

			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			#pragma vertex vert
			#pragma fragment frag

			float4 _DiffuseColor;
			float4 _SpecularColor;
			float _Gloss;

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
			};

			v2f vert(appdata_full v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//拿到世界空间下的法线
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				//拿到世界空间下的位置
				o.worldPos = mul(unity_ObjectToWorld,v.vertex);
				return o;
			}

			fixed3 frag(v2f i):SV_TARGET{
				//拿到环境光的颜色
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//拿到世界空间下的法线
				float3 worldNormal = normalize(i.worldNormal);
				//拿到世界空间下的光线方向
				float3  worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//拿到世界空间下的视角方向
				float3 worldViewDir = normalize(WorldSpaceViewDir(i.pos));
				// //拿到世界空间下的视角方向
				// float3 worldViewDir = normalize(_WorldSpaceCameraPos-i.worldPos);
				//拿到世界空间下的反射方向
				float3 reflectLightDir =normalize(reflect(-_WorldSpaceLightPos0,worldNormal));
				//计算漫反射
				float3 lambert = _DiffuseColor * _LightColor0.xyz*saturate(dot(worldNormal,worldLightDir));
				//计算高光反射 
				float3 specular = _DiffuseColor * _LightColor0.xyz*_SpecularColor*pow(saturate(dot(reflectLightDir,worldNormal)),_Gloss);
				//最终颜色
				fixed3 color = lambert+specular+ambient;
				return color;
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}