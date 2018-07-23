Shader "ZDH/SceneModel_08"
{
	Properties{
		_MainTex("MainTex",2D) = "white"{}
		_Color("Color",Color) = (1,1,1,1)
	}

	SubShader{
		Tags{
			"Queue" = "Transparent"
			"RendType" = "Transparent"
			"IngnorProjector" = "True"
		}

		Blend SrcAlpha OneMinusSrcAlpha

		pass{
			Name "map"

			Cull Off

			CGPROGRAM

			sampler2D _MainTex;
			float4 _Color;

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
				return ot;
			}

			half4 frag(v2f data):COLOR{
				half4 c = tex2D(_MainTex,data.uv.xy) * _Color;
				return c;
			}

			ENDCG

		}
	}
}
