Shader "Unlit/03_Specular"
{
    Properties
	{
		_Color("Color",color)=(1,0,0,1)
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
            // Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members worldPosition)
        #pragma exclude_renderers d3d11
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			fixed4 _Color;

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 worldPosition;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex =UnityObjectToClipPos(v.vertex);
				o.worldPosition=mul(unity_ObjectToWorld,v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 eyeDir =normalize(_WorldSpaceCameraPos.xyz-i.worldPosition);
				float3 lightDir =normalize(_WorldSpaceLightPos0);
				i.normal=normalize(i.normal);
				float3 reflectDir=-lightDir+2*i.normal*dot(i.normal,lightDir);
				fixed4 specular=pow(saturate(dot(reflectDir,eyeDir)),20)*_LightColor0;
				return specular;
			}
			ENDCG
		}
	}
}
