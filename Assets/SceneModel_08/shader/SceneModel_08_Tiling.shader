Shader "ZDH/SceneModel_08_Tiling"
{
	Properties{
		_MainTex("MainTex",2D) = "white"{}
		_DetailTex("DetailTex",2D) = "white"{}
		_Color("Color",Color) = (1,1,1,1)
		_AlphaValue("AlphaValue",Range(0,1)) = 1 
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
			sampler2D _DetailTex;
			float _AlphaValue;
			float4 _Color;
			float4 _MainTex_ST;
			float4 _DetailTex_ST;

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f{
				float4 pos:POSITION;
				float4 uv:TEXCOORD0;
			};


			v2f vert(appdata_base data){
				v2f ot;
				ot.pos = UnityObjectToClipPos(data.vertex);
				ot.uv = data.texcoord;
				ot.uv.xy = TRANSFORM_TEX(data.texcoord,_MainTex);
				return ot;
			}

			half4 frag(v2f data):COLOR{
				half4 c = tex2D(_MainTex,data.uv.xy) * _Color *_AlphaValue;
				half4 d = tex2D(_DetailTex,data.uv.xy) * _Color *_AlphaValue;
				return c*d;
			}

			ENDCG

		}
	}
}
