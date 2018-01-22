Shader "Kamaly/PaintingUv"
{
	Properties{
		_MainTex("MainTex", 2D) = "white" 
		_BackGroundTex("BackGroundTex", 2D) = "white"
		_Brush("Brush", 2D) = "white"
		_BrushScale("BrushScale", FLOAT) = 0.1
		_ControlColor("ControlColor", VECTOR) = (0, 0, 0, 0)
		_PaintUV("Hit UV Position", VECTOR) = (0, 0, 0, 0)
	}

		SubShader{
		CGINCLUDE
		struct app_data {
		float4 vertex:POSITION;
		float4 uv:TEXCOORD0;
	};

	struct v2f {
		float4 screen:SV_POSITION;
		float4 uv:TEXCOORD0;
	};

	sampler2D _MainTex;
	sampler2D _Brush;
	sampler2D _BackGroundTex;
	float4 _PaintUV;
	float _BrushScale;
	float4 _ControlColor;
	ENDCG

		// Pass BackGround
		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
		bool IsPaintRange(float2 mainUV, float2 paintUV, float brushScale) {
		return
			paintUV.x - brushScale < mainUV.x &&
			mainUV.x < paintUV.x + brushScale &&
			paintUV.y - brushScale < mainUV.y &&
			mainUV.y < paintUV.y + brushScale;
	}

	v2f vert(app_data i) {
		v2f o;
		o.screen = UnityObjectToClipPos(i.vertex);
		o.uv = i.uv;
		return o;
	}

	float4 frag(v2f i) : SV_TARGET{
		float h = _BrushScale;
	float4 mainColor = tex2D(_MainTex, i.uv.xy);

	float4 background = tex2D(_BackGroundTex, i.uv);
	return background;
	}
		ENDCG
	}


		// Pass Brush
		Blend SrcAlpha OneMinusSrcAlpha
		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
		bool IsPaintRange(float2 mainUV, float2 paintUV, float brushScale) {
		return
			paintUV.x - brushScale < mainUV.x &&
			mainUV.x < paintUV.x + brushScale &&
			paintUV.y - brushScale < mainUV.y &&
			mainUV.y < paintUV.y + brushScale;
	}

	v2f vert(app_data i) {
		v2f o;
		o.screen = UnityObjectToClipPos(i.vertex);
		o.uv = i.uv;
		return o;
	}

	float4 frag(v2f i) : SV_TARGET{
		float h = _BrushScale;
	float4 mainColor = tex2D(_MainTex, i.uv.xy);
	float4 brushColor = float4(1, 1, 1, 1);

	if (IsPaintRange(i.uv, _PaintUV, h)) {
		float2 uv = (i.uv - _PaintUV) / h * 0.5 + 0.5;
		return  tex2D(_Brush,i.uv);
	}
	return mainColor;
	}
		ENDCG
	}

		
	}
}