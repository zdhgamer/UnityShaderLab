Shader "ZDHZDH/ThreeDSnow/ThreeDSnowSimple"{
	Properties{
		_MainTex("MainTex",2D) = "white"{}
		_SnowStep("Snow",Range(0,1)) = 0.5
	}

	SubShader{
		Tags{
			"Queue"="Geometry"
			"RenderType"="Opaque"
		}

		pass{
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _SnowStep;

			struct v2f{
				float4 pos:SV_POSITION;
				float2 uvMainTexture:TEXCOORD0;
				float4 snowColor:TEXCOORD1;
			};

			v2f vert(appdata_full data){
				v2f o;
				o.pos = UnityObjectToClipPos(data.vertex);
				o.uvMainTexture = TRANSFORM_TEX(data.texcoord,_MainTex);
				o.snowColor = step(1-_SnowStep,data.normal.y)*fixed4(1,1,1,1);
				return o;
			}

			fixed4 frag(v2f v):SV_TARGET{
				fixed4 color = tex2D(_MainTex,v.uvMainTexture) + v.snowColor;
				return color;
			}

			ENDCG

		}
	}

	Fallback "Diffuse"
}