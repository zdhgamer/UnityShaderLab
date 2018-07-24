Shader"ZDH/fragment"{
	Properties{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
		_Specular("Specular",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8,256)) = 20
	}

	SubShader{
		Tags{
			"LightMode" = "ForwardBase"
		}

		pass{
			Name "Phong1"

			CGPROGRAM

			float4 _Diffuse;
			float4 _Specular;
			float _Gloss;

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct v2f{
				float4 pos : SV_POSITION;
				float3 worldNormal : NORMAL;
				float3 worldPos : TEXCOORD1;
			};

			v2f vert(appdata_base v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);	
				o.worldPos = mul(unity_ObjectToWorld,v.vertex);				
				o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
				return o;
			}

			fixed4 frag(v2f i):SV_TARGET{
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz* _Diffuse;
				float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				//float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 lambert = _LightColor0.xyz * _Diffuse * saturate(dot(normalize(i.worldNormal),worldLightDir));

				float3 worldReflect = normalize(reflect(-worldLightDir,i.worldNormal));
				float3 worldViewDir = normalize(_WorldSpaceCameraPos.xyz-i.worldPos.xyz);
				float3 specular = _LightColor0.rgb*_Specular.rgb*pow(saturate(dot(worldReflect,worldViewDir)),_Gloss);
				float3 c = ambient + specular +lambert;
				return fixed4(c,1);
			}

			ENDCG

		}
	}
}