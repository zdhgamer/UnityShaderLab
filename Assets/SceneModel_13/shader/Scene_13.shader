Shader "ZDH/Scene13"
{
    Properties
    {
         _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _FlowlightTex ("Add Move Texture", 2D) = "white" {}
        _FlowlightColor ("Flowlight Color", Color) = (0, 0, 0, 1)
        _Power ("Power", float) = 1
        _SpeedX ("SpeedX", float) = 1
        _SpeedY ("SpeedY", float) = 0

    }

    SubShader
    {
        Tags
        { 
            "Queue"="Transparent" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent" 
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        

        Pass
        {
            CGPROGRAM        
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                sampler2D _MainTex;
                fixed4 _Color;
                fixed4 _FlowlightColor;
                float _Power;
                sampler2D _FlowlightTex;
                fixed4 _FlowlightTex_ST;
                fixed _SpeedX;
                fixed _SpeedY;
                
                struct appdata_t
                {
                    float4 vertex : POSITION;
                    float2 texcoord : TEXCOORD0;
                };

                struct v2f
                {
                    float4 vertex : SV_POSITION;
                    half2 texcoord : TEXCOORD0;
                    half2 texflowlight : TEXCOORD1;
                };
                
                v2f vert(appdata_t IN)
                {
                    v2f OUT;
                    OUT.vertex = UnityObjectToClipPos(IN.vertex);
                    OUT.texcoord = IN.texcoord;
                    OUT.texflowlight = TRANSFORM_TEX(IN.texcoord, _FlowlightTex);
                    OUT.texflowlight.x += _Time * _SpeedX;
                    OUT.texflowlight.y += _Time * _SpeedY;
                    return OUT;
                }

                fixed4 frag(v2f IN) : SV_Target
                {
                    fixed4 c = tex2D(_MainTex, IN.texcoord);
                    fixed4 cadd = tex2D(_FlowlightTex, IN.texflowlight) * _Power * _FlowlightColor;
                    c.rgb += cadd.rgb;
                    //c.rgb *= c.a;
                    return c;
                }
            ENDCG
        }
    }
}