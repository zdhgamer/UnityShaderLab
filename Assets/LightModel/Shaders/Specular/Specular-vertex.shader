Shader"ZDHZDH/LightModel/Specular-vertex"{
	Properties{
		_DiffuseColor("_DiffuseColor",Color)=(1,1,1,1)
		_SpecularColor("_SpecularColor",Color)=(1,1,1,1)
		_Gloass("_Gloass",Range(8,255))=20
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
			float _Gloass;

			struct v2f{
				float4 pos:SV_POSITION;
				float3 color:COLOR;
			};

			v2f vert(appdata_full v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//拿到环境光的颜色
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//拿到世界空间下的法线
				float3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
				//拿到世界空间下的位置
				float3 worldPos =  mul(unity_ObjectToWorld,v.vertex);
				//拿到世界空间下的视角方向
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				//拿到世界空间下的光线方向
				float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//计算反射光线的方向
				float3 worldReflectDir = normalize(reflect(-worldLightDir,worldNormal));
				//计算漫反射颜色
				float3 lambertColor = _DiffuseColor*saturate(dot(worldNormal,worldLightDir))*_LightColor0.xyz;
				//计算高光颜色
				float3 specular =_SpecularColor*pow(saturate(dot(worldReflectDir,worldViewDir)),_Gloass)*_DiffuseColor*_LightColor0.xyz;
				//最终颜色
				o.color = lambertColor+specular+ambient;
				return o;
			}

			fixed3 frag(v2f i):SV_TARGET{
				return i.color;
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}