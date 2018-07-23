Shader "Unlit/SceneModel_05"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Color",Color) = (1,1,1,1)
		_CutOut("CutOut",Range(0,1)) = 0.4
		_RangeValue("Range",Range(0,1)) = 1
		_RectTex("RectTex",2D) = "white"{}
		_CubeTex("CubeTex",Cube) = "White"{}
		_FloatValue("Float",Float) = 0.1 
		_VectorValue("Vector",Vector) = (1,1,1,1)
	}
	SubShader
	{
		Tags {
			"Queue" = "Transparent" 
			"RenderType"="Transparent" }

		AlphaTest Less[_CutOut]

		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
