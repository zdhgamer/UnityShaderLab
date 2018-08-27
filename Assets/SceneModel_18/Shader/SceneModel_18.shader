Shader "ZDH/Scene_18"{
	Properties{
		//消融程度
		_ClipAmount("ClipAmount",Range(0,1))=0.0
		_LineWidth("LingWidth",Range(0,0.2)) = 0.1
		_MainTexture("MainTexture",2D) = "white"{}
		_BumpTexture("BumpTexture",2D) = "bump"{}
		_ClipTexture("ClipTexture",2D) = "white"{}
		_ClipColorOne("ClipColorOne",Color) = (1,1,1,1)
		_ClipColorTwo("ClipColorTwo",Color) = (1,1,1,1)
	}
	SubShader{

		Tags{"RenderType"="Opaque" "Queue"="Geometry"}

		pass{
			Tags { "LightMode"="ForwardBase" }
			Cull Off

			CGPROGRAM

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			#pragma multi_compile_fwdbase

			#pragma vertex vert
			#pragma fragment frag

			float _ClipAmount;
			float _LineWidth;
			sampler2D _MainTexture;
			float4 _MainTexture_ST;
			sampler2D _BumpTexture;
			float4 _BumpTexture_ST;
			sampler2D _ClipTexture;
			float4 _ClipTexture_ST;
			float _ClipColorOne;
			float _ClipColorTwo;

			struct v2f{
				float4 pos:SV_POSITION;
				float2 uvMainTexture:TEXCOORD0;
				float2 uvBumpTexture:TEXCOORD1;
				float2 uvClipTexture:TEXCOORD2;
				float3 lightDir:TEXCOORD3;
				float3 worldPos:TEXCOORD4;
				SHADOW_COORDS(5)
			};



			v2f vert(appdata_full v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.uvMainTexture = TRANSFORM_TEX(v.texcoord, _MainTexture);
				o.uvBumpTexture = TRANSFORM_TEX(v.texcoord,_BumpTexture);
				o.uvClipTexture = TRANSFORM_TEX(v.texcoord,  _ClipTexture);
				TANGENT_SPACE_ROTATION;
				o.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex));
				TRANSFER_SHADOW(o);
				return o;
			};

			fixed4 frag(v2f i):SV_TARGET{
				fixed3 clipColor = tex2D(_ClipTexture,i.uvClipTexture).rgb;
				//噪声的rgb值都是一样的
				clip(clipColor.r - _ClipAmount);
				fixed3 lightDir = normalize(i.lightDir);
				fixed3 normalDir = UnpackNormal(tex2D(_BumpTexture,i.uvBumpTexture));
				fixed3 mainColor = tex2D(_MainTexture,i.uvMainTexture);
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*mainColor;
				fixed3 diffuse = mainColor*_LightColor0.rgb*saturate(dot(lightDir,normalDir));
				fixed t = 1 - smoothstep(0.0,_LineWidth,clipColor.r - _ClipAmount);
				fixed3 clipColorLerp = lerp(_ClipColorOne,_ClipColorTwo,t);
				clipColorLerp = pow(clipColorLerp,5);
				UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);
				//step(a,b)->如果a>b,返回0，否则返回1
				fixed3 finalColor = lerp(ambient+diffuse*atten,clipColorLerp,t*step(0.0001,_ClipAmount));
				return fixed4(finalColor,1.0f);
			};

			ENDCG

		}

		Pass {
			Tags { "LightMode" = "ShadowCaster" }
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#pragma multi_compile_shadowcaster
			
			#include "UnityCG.cginc"
			
			fixed _ClipAmount;
			sampler2D _ClipTexture;
			float4 _ClipTexture_ST;
			
			struct v2f {
				V2F_SHADOW_CASTER;
				float2 uvClipTexture : TEXCOORD1;
			};
			
			v2f vert(appdata_base v) {
				v2f o;
				
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				
				o.uvClipTexture = TRANSFORM_TEX(v.texcoord, _ClipTexture);
				
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {
				fixed3 burn = tex2D(_ClipTexture, i.uvClipTexture).rgb;
				
				clip(burn.r - _ClipAmount);
				
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
	}
}