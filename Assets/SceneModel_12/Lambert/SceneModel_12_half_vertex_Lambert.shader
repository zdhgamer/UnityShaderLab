Shader "ZDH/Scene12_vertex_half_Lambert"{
	Properties{
		_DissfuseColor("Dissfule",Color)=(1,1,1,1)
	}

	SubShader{
		Tags{
			"LightMode" = "ForwardBase"
		}
		pass{
			Name "Lambert1"

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _DissfuseColor;

			struct v2f{
				float4 pos:SV_POSITION;
				float4 color:COLOR;
			};

			v2f vert(appdata_base v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				float3 normal =normalize(UnityObjectToWorldNormal(v.normal));
				float3 lightdir = normalize(WorldSpaceLightDir(v.vertex));
				//float3 lightdir = normalize(_WorldSpaceLightPos0.xyz); 
				o.color = UNITY_LIGHTMODEL_AMBIENT + (0.5*dot(normal,lightdir)+0.5)*_DissfuseColor*_LightColor0;
				return o;	
			}
			
			fixed4 frag (v2f i):SV_TARGET{
				return i.color;
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}