Shader"ZDHZDH/LIGHTMODEL/MyLambert_fragment"{
	Properties{
		_DiffuseColor("_DiffuseColor",Color)=(1,1,1,1)
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

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			float4 _DiffuseColor;

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldPos:TEXCOORD0;
				float3 worldNormalDir:TEXCOORD2;
			};

			v2f vert(appdata_full v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex);
				o.worldNormalDir = UnityObjectToWorldNormal(v.normal);
				return o;
			}

			fixed3 frag(v2f i):SV_TARGET{
				float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 worldNormalDir = normalize(i.worldNormalDir);
				fixed3 color = _DiffuseColor*(dot(worldLightDir,worldNormalDir)*0.5+0.5)*_LightColor0.xyz;
				return color;
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}