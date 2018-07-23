Shader "ZDH/SceneModel_10"
{
	Properties{
		_MainTex("MainTex",2D) = "white"{}
		_Color("Color",Color) = (1,1,1,1)
		_AlphaValue("AlphaValue",Range(0,1)) = 1 
		_LightMap("LightMap",2D) = "white"{}
	}

	SubShader{
		Tags{
			"Queue" = "Transparent"
			"RendType" = "Transparent"
			"IngnorProjector" = "True"
		}

		Blend SrcAlpha OneMinusSrcAlpha

		pass{
			Name "Rotate"

			Cull Off

			CGPROGRAM

			sampler2D _MainTex;
			float _AlphaValue;
			float4 _Color;
			sampler2D _LightMap;

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f{
				float4 pos:POSITION;
				float4 uv:TEXCOORD0;
				float4 lmuv:TEXCOORD1;
			};


			v2f vert(appdata_full data){
				v2f ot;
				ot.pos = UnityObjectToClipPos(data.vertex);
				ot.uv = data.texcoord;
				ot.lmuv = data.texcoord1;
				return ot;
			}

			half4 frag(v2f data):COLOR{

				half4 c = tex2D(_MainTex,data.uv.xy) * _Color *_AlphaValue;
				half4 l = tex2D(_LightMap,data.lmuv.xy);
				return c * l;
			}

			ENDCG

		}
	}
}
