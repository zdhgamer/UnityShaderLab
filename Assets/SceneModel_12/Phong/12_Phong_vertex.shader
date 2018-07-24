Shader"ZDH/VertexPhong"{
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
			Name "Phong"

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
				float4 pos:SV_POSITION;
				float3 color:COLOR;
			};

			v2f vert(appdata_full v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);	
				float4 worldPos = mul(unity_ObjectToWorld,v.vertex);
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				float3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
				float3 worldLightDir = normalize(WorldSpaceLightDir(v.vertex));
				float3 worldViewDir = normalize(_WorldSpaceCameraPos.xyz-worldPos.xyz);
				float3 lambert = _LightColor0.xyz*_Diffuse*saturate(dot(worldNormal,worldLightDir));
				float3 worldReflect = normalize(reflect(-worldLightDir,worldNormal));
				float3 specular = _LightColor0.rgb*_Specular.rgb*(pow(saturate(dot(worldReflect,worldViewDir)),_Gloss));
				o.color = ambient + specular +lambert;
				return o;
			}

			fixed4 frag(v2f i):SV_TARGET{
				return fixed4(i.color,1);
			}

			ENDCG

		}
	}
}