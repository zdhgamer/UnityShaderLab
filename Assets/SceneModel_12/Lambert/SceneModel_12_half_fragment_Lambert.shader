Shader "ZDH/Scene12_fragment_half_Lambert"{
	Properties{
		_DissfuseColor("Dissfule",Color)=(1,1,1,1)
	}

	SubShader{
		Tags{
			"LightMode" = "ForwardBase"
		}
		pass{
			Name "Lambert2"

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _DissfuseColor;

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldnoraml:TEXCOORD;
				float3 worldListDir:TEXCOORD1;
			};

			v2f vert(appdata_base v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldnoraml = normalize(UnityObjectToWorldNormal(v.normal));
				o.worldListDir = normalize(WorldSpaceLightDir(v.vertex));
				return o;	
			}
			
			fixed4 frag (v2f i):SV_TARGET{
				float3 c = UNITY_LIGHTMODEL_AMBIENT.xyz + (0.5*dot(i.worldnoraml,i.worldListDir)+0.5)*_DissfuseColor.xyz*_LightColor0.xyz;
				return fixed4(c.xyz,1);
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}