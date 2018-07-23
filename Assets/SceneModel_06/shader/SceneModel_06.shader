Shader"ZDH/SceneModel_06"{

	Properties{
		_MainTex("MainTex",2D) = "white"{}
		_Color("Color",Color) = (1,1,1,1)
		_AlphaValue("AlphaValue",Range(0,1)) = 0.5
	}

	SubShader
	{
		tags{
			"Queue" = "Transparent" 
			"RenderType" = "Transparent" 
			"IgnoreProjector" = "True"
			}

		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass
		{
			Name "Simple"
			Cull off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			float4 _Color;
			sampler2D _MainTex;
			float _AlphaValue;
			
			struct v2f
			{
				float4 pos:POSITION;
				float4 uv:TEXCOORD0;
			};
			
			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}
			
			half4 frag(v2f i):COLOR
			{
				half4 c = tex2D(_MainTex ,i.uv.xy) * _Color *_AlphaValue;
				return c;
			}
			
			ENDCG
		}
	}

	//FallBack "Diffuse"
}