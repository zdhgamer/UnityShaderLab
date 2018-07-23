Shader "ZDH/SceneModel_07"
{
	Properties{
		_MainTex("MainTex",2D) = "white"{}
		_Color("Color",Color) = (1,1,1,1)
		_AlphaValue("AlphaValue",Range(0,1)) = 1 
		_RotateSpeed("RotateSpeed",Range(0,100)) = 30
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
			float _RotateSpeed;

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

				float2 uv = data.uv- float2(0.5,0.5);
				float2 rotate = float2(cos(_RotateSpeed*_Time.x),sin(_RotateSpeed*_Time.x));
				uv = float2(uv.x*rotate.x -uv.y*rotate.y,uv.x*rotate.y+uv.y*rotate.x);
				uv+=float2(0.5,0.5);
				half4 c = tex2D(_MainTex,uv.xy) * _Color *_AlphaValue;
				return c;
			}

			ENDCG

		}
	}
}
