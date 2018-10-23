Shader "ZDHZDH/ThreeDSnow/ThreeDSnowWorld"{
	Properties{
		_mainTex("MainTex",2D) = "white"{}
		_snowTex("SnowTex",2D) = "white"{}
		_snowStep("SnowStep",Range(0,1)) = 0.5
	}

	SubShader{
		Tags{
			"RenderType" = "Opaque"
			"Queue" = "Geometry"
		}

		pass{
			
			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag 

			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			sampler2D _mainTex;
			float4 _mainTex_ST;
			sampler2D _snowTex;
			float4 _snowTex_ST;
			float _snowStep;

			struct v2f{
				float4 pos:SV_POSITION;
				float2 uvMainTex:TEXCOORD0;
				float2 uvSnowTex:TEXCOORD1;
				float3 worldNormal:TEXCOORD2;
			};

			v2f vert(appdata_full data){
				v2f o;
				o.pos = UnityObjectToClipPos(data.vertex);
				o.uvMainTex = TRANSFORM_TEX(data.texcoord,_mainTex);
				o.uvSnowTex = TRANSFORM_TEX(data.texcoord1,_snowTex);
				o.worldNormal = UnityObjectToWorldNormal(data.normal);
				return o;
			}

			fixed4 frag(v2f v):SV_TARGET{
				fixed4 mainColor = tex2D(_mainTex,v.uvMainTex);
				fixed4 snowColor = tex2D(_snowTex,v.uvSnowTex);
				fixed temp = step(lerp(1,-1,_snowStep),dot(float3(0,1,0),v.worldNormal))*snowColor;
				return mainColor+temp;
			}

			ENDCG

		}
	}

	Fallback "Diffuse"
}