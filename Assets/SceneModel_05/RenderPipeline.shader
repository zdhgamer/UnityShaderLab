// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShader/RenderPipeline" {
	
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_CubeMap ("Cube Map", Cube) = "" {}
		_FloatValue ( "FloatValue", float) = 100 
		_VectorValue( "VectorValue", vector) = (1,1,1,1)
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_RangeValue("RangeValue", Range(0, 1)) = 0.5
		_CutOut("Cutout", Range(0,1)) = 0.4
	}
	SubShader {
		tags{"Queue" = "Transparent" }
		
		Cull off
		//ColorMask RGB
		AlphaTest Less[_CutOut]
		Pass{
			tags{
				"LightModel" = "ShadowCaster"
			}
		// Dont write to the depth buffer
		ZWrite off

		// Set up alpha blending
		//Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 3.0
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		float4 _Color;

		struct appdata{
			float4 vertex:POSITION;
			float4 texcoord:TEXCOORD0;
		};

		struct v2f{
			float4 pos:SV_POSITION;
			float4 texcoord : TEXCOORD0;
		};

		v2f vert(appdata v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.texcoord = v.texcoord;
			return o;
		}

		half4 frag(v2f i):COLOR0
		{
			half4 col = _Color * tex2D(_MainTex, i.texcoord.xy);
			return col;
		}

		ENDCG
		}
		

	} 

	
	FallBack "Diffuse"
}
