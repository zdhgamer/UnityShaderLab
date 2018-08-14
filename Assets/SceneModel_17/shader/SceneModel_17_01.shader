Shader "ZDH/SceneModel_17_01"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Ex("EX",float) = 1
		_Power("Power",float) = 1
		_ExColor("_ExColor",Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 worldPos:TEXCOORD1;
				float3 lightDir:TEXCOORD2;
				float3 viewDir:TEXCOORD3;
				float3 worldNormal:TEXCOORD4;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Ex;
			float _Power;
			float4 _ExColor;
			
			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex);
				o.lightDir = UnityWorldSpaceLightDir(o.worldPos);
				o.viewDir = UnityWorldSpaceViewDir(o.worldPos);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//float3 atten = UNITYAT
				float rom = 1 - saturate(dot(normalize(i.worldNormal),normalize(i.viewDir)));
				fixed4 c1 = pow(rom,_Ex)*_Power*_ExColor;
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv) + c1;
				return col;
			}
			ENDCG
		}
	}
}
