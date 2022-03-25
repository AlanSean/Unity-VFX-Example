Shader "Unlit/Dissolve"
{
  Properties
  {
    [MainColor] [HDR] _MainColor ("Main Color", Color) = (1,1,1,1)
    [MainTexture] _MainTex ("Main Texture", 2D) = "white" {}

    [HDR] _Dissolve ("Dissolve", Range(0,1)) = 0

    [HDR] _EdgeColor ("Main Color", Color) = (1,1,1,1)
    _EdgeWidth ("Edge Width", Range(0,0.1)) = 0
  }

  // Universal Render Pipeline subshader. If URP is installed this will be used.
  SubShader
  {
    Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalRenderPipeline"}

    Pass
    {
      Tags { "LightMode"="UniversalForward" }

      HLSLPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      
      #include "./Unity_SimpleNoise_float.hlsl" 
      #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

      struct Attributes
      {
        float4 positionOS   : POSITION;
        float2 uv           : TEXCOORD0;
      };

      struct Varyings
      {
        float2 uv           : TEXCOORD0;
        float4 positionHCS  : SV_POSITION;
      };


      TEXTURE2D(_MainTex);
      SAMPLER(sampler_MainTex);
      
      CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_ST;
        half4 _MainColor,_EdgeColor;
        float _Dissolve, _EdgeWidth;
      CBUFFER_END

      Varyings vert(Attributes IN)
      {
        Varyings OUT;
        OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
        OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
        return OUT;
      }

      half4 frag(Varyings IN) : SV_Target
      {
        float Noise;//噪声
        half4 color;//颜色
        Noise = Unity_SimpleNoise_float(IN.uv, 50);
        color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);

        clip(color*Noise - _Dissolve);
        half4 edgeColor = lerp(_EdgeColor, _Dissolve, color*Noise - _Dissolve);
        color *= lerp(color,edgeColor,_Dissolve);
        return color;
      }
      ENDHLSL
    }
  }

}
