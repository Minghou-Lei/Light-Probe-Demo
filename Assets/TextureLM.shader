Shader "Custom/TextureLM"
{
	Properties
	{
		_Color("Color",Color) = (0,0,0,0)
		_SHLightingScale("LightProbe influence scale",float) = 1
	}
	SubShader
	{
		Pass
		{
			Tags
			{
				"Queue"="Geometry""LightMode"="ForwardBase""RenderType"="Opaque"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed3 SHLighting : COLOR;
			};

			float _SHLightingScale;
			float4 _Color;

			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float3 worldNormal = mul((float3x3)unity_ObjectToWorld, v.normal);
				o.SHLighting = ShadeSH9(float4(worldNormal, 1));
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = _Color;
				col.rgb *= i.SHLighting;
				return col * _SHLightingScale;
			}
			ENDCG
		}
	}
}