Shader "ZDH/SceneModel_09"
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

			float2 moveuv(float4 vertuv){
				float texturenum = 12.0;
				float timeper = 100;
				float index = frac(_Time.x/texturenum*timeper);
				float2 uvscale = float2(1/texturenum,1);
				if(index<=uvscale.x)
				{
					return vertuv*uvscale;
				}
				else if(index<=2*uvscale.x){
					return vertuv*uvscale +1*float2(uvscale.x,0);
				}
				else if(index<=3*uvscale.x){
					return vertuv*uvscale +2*float2(uvscale.x,0);
				}
				else if(index<=4*uvscale.x){
					return vertuv*uvscale +3*float2(uvscale.x,0);
				}
				else if(index<=5*uvscale.x){
					return vertuv*uvscale +4*float2(uvscale.x,0);
				}
				else if(index<=6*uvscale.x){
					return vertuv*uvscale +5*float2(uvscale.x,0);
				}
				else if(index<=7*uvscale.x){
					return vertuv*uvscale +6*float2(uvscale.x,0);
				}
				else if(index<=8*uvscale.x){
					return vertuv*uvscale +7*float2(uvscale.x,0);
				}
				else if(index<=9*uvscale.x){
					return vertuv*uvscale +8*float2(uvscale.x,0);
				}
				else if(index<=10*uvscale.x){
					return vertuv*uvscale +9*float2(uvscale.x,0);
				}
				else if(index<=11*uvscale.x){
					return vertuv*uvscale +10*float2(uvscale.x,0);
				}
				else{
					return vertuv*uvscale +11*float2(uvscale.x,0);
				}
				
				 return vertuv;
			}

			v2f vert(appdata_base data){
				v2f ot;
				ot.pos = UnityObjectToClipPos(data.vertex);
				ot.uv.xy = moveuv(data.texcoord);
				return ot;
			}

			half4 frag(v2f data):COLOR{
				half4 c = tex2D(_MainTex,data.uv.xy) * _Color *_AlphaValue;
				return c;
			}

			ENDCG

		}
	}
}
