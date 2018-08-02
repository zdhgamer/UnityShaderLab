Shader "ZDH/Scene15_01"
{
	Properties
	{
		_MainTex ("Texture", Cube) = "white" {}
		_Diffuse("Diffuse",Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { 
			"RenderType"="Opaque" 
			"LightMode" = "ForwardBase"
			}
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				fixed3 worldPos:TEXCOORD1;
				fixed3 worldNoraml:TEXCOORD2;
				fixed3 worldViewDir:TEXCOORD3;
				fixed3 worldFrelect:TEXCOORD4;
				SHADOW_COORDS(5)
				UNITY_FOG_COORDS(1)
			};

			samplerCUBE _MainTex;
			float4 _MainTex_ST;
			float4 _Diffuse;
			
			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex);
				o.worldNoraml = UnityObjectToWorldNormal(v.normal);
				o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
				o.worldFrelect = reflect(-o.worldViewDir,o.worldNoraml);
				UNITY_TRANSFER_FOG(o,o.vertex);
				TRANSFER_SHADOW(o);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = texCUBE(_MainTex,i.worldFrelect);
				fixed3 am = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 normal = normalize(i.worldNoraml);
				fixed3 light = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 view = normalize(i.worldViewDir);
				fixed3 diffuse = am + _LightColor0.xyz*_Diffuse*saturate(dot(normal,light));
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
				return fixed4(col.xyz+diffuse.xyz*atten,1);
			}
			ENDCG
		}
	}
	FallBack "Reflective/VertexLit"
}
