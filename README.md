# 光照探针

Status: 间接光照

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/ligfqRLdBH.gif](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/ligfqRLdBH.gif)

光照探针技术

Unity的预计算实时GI或者烘焙照明只对静态的物体起作用，对于可移动的物体，需要用一种新的技术来解决光照问题。为了让动态物体（如交互式场景元素或角色）能够获得静态物体反弹的光线，需要将这些光照信息记录下来，并且在运行时能快速读取和使用。通过在场景中放置采样点捕捉各个方向的光线来实现动态物体接收间接光的功能。这些采样点记录的光照信息被编码成可以在游戏过程中快速计算值。在Unity中，我们将这些采样点称为“光照探头”。

# Light Probe（光照探针）

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled.png)

Light Probe遍布场景里面

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/tqasMraOc8.gif](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/tqasMraOc8.gif)

当动态物体移动时，最近的一组Light Probe被激活

这个技术是让动态物体从场景接收间接光的有效方法。尽管使用该技术的动态物体不会产生反射光，但通常这没有什么明显的影响。因为探测照明的物体往往是较小的物体，能反射的光很少，对周围环境的影响很有限。

# 什么是Probe Lighting(探测照明)？

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/KxugK50GYC.gif](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/KxugK50GYC.gif)

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%201.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%201.png)

场景中的光照探针，保存了该位置的环境光信息

探测照明是一种用于**实时渲染**的高级照明技术，常用于场景中的**角色或非静态(Static)物体**的照明。探测照明运行时效率非常高并且预计算也很快。

探测照明通过3D空间中的探头对入射光进行采样并将这些信息通过**球谐函数编码**处理后保存成文件。这些信息占用的存储空间很少并且在运行时解码非常快。场景中的Shader可以使用这些信息来模拟物体表面的光照。

当然了，有优势也会有相应的劣势。在一定的计算量下，**探测照明很难表现变化复杂的照明效果**。但是如果**增加模拟精度，计算代价也会随之增高**。基于性能的考虑，Unity限制了计算的精度。另外一个，由于一个3D位置只用了一个球来进行模拟，在**大模型以及较平的模型表面上的光照效果可能会不太好**。

除去这些限制，**探测照明在小的、凸状的物体上有很好的效果，同时性能很好**。

# Spherical Harmonic Lighting（球谐光照）

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Rotating_spherical_harmonics.gif](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Rotating_spherical_harmonics.gif)

实值的球谐函数 Ylm，l = 0 到 4 （由上至下），m=0 到 4（由左至右）

球谐光照在现代游戏图形渲染领域应用很广，用于快速的模拟复杂的实时光照，例如unity中的light probe以及一些不重要的实时光源，可以用球谐光照快速的计算。球谐光照的优点是运行时的计算量与光源的数量无关，如果参数足够却可以较好的模拟实时的光照结果。
球谐光照的原理不仅涉及图形学，概率论，信号分析，微积分等大量复杂数学公式

[Unity-Technologies/Graphics](https://github.com/Unity-Technologies/Graphics/blob/9320b6662f697400737dbcbe65d685f6f114ed2d/com.unity.render-pipelines.high-definition/Runtime/Lighting/VolumetricLighting/VolumetricLighting.cs)

[%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/StupidSH36.pdf](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/StupidSH36.pdf)

Stupid Spherical Harmonics (SH) Tricks Paper

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%202.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%202.png)

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%203.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%203.png)

实值的球谐函数 Ylm，l = 0 到 4 （由上至下），m=0 到 4（由左至右）

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%204.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%204.png)

360°展开对应的空间

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%205.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%205.png)

级数越高，探针的取样越精准

# Unity 中的 Light Probe

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%206.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%206.png)

上图是将光探头重建为1到6级球谐的图像。 最终的图像是投影的光探头

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%207.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%207.png)

空间中某一点的环境光照会由四个Light Probe构成的四面体中插值求得，其中每个Light Probe在光照烘焙过程中会储存周围360°的环境光照

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%208.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%208.png)

Unity 中光照探针烘焙

探测照明在运行时耗费的资源很少并且预计算也很快。但是，为了尽可能优化性能，在摆放光照探头时也有一些注意事项。

1、以整齐的密集网格排列会减少摆放时的工作量，但是这样会造成很多探头的浪费，因为很多探头在相近的位置接收到的光照都类似，在相似的光照位置，只需要一个或几个探头就足够了。

2、为了提高探头的效率，应该在光照变化比较大的地方多放置探头，在光照变化不大的地方少放探头。比如应该在从明亮到阴影的过渡位置多放探头，在反射光较强烈的表面多放置探头，在大的平面上少放探头。

# 代码实现

[Unity Shader球谐光照解析-腾讯游戏学院](https://gameinstitute.qq.com/community/detail/124147)

三阶的基函数系数分别用了两个子函数来读取，其中：

```cpp
// SH lighting environment
    half4 unity_SHAr;
    half4 unity_SHAg;
    half4 unity_SHAb;
    half4 unity_SHBr;
    half4 unity_SHBg;
    half4 unity_SHBb;
    half4 unity_SHC;
```

Unity通过烘培时的光线追踪计算出其光照原始信号，然后投影到基函数并存储其系数，我们在Shader中可通过 ShadeSH9 函数获取重建信号，ShadeSH9 实现在 UnityCG.cginc 文件中，具体代码如下：

```cpp
// normal should be normalized, w=1.0
half3 SHEvalLinearL0L1 (half4 normal)
{
    half3 x;

    // Linear (L1) + constant (L0) polynomial terms
    x.r = dot(unity_SHAr,normal);
    x.g = dot(unity_SHAg,normal);
    x.b = dot(unity_SHAb,normal);

    return x;
}
```

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%209.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%209.png)

L = 0 和 L = 1时的伴随勒让德多项式 

```cpp
// normal should be normalized, w=1.0
half3 SHEvalLinearL2 (half4 normal)
{
    half3 x1, x2;
    // 4 of the quadratic (L2) polynomials
    half4 vB = normal.xyzz * normal.yzzx;
    x1.r = dot(unity_SHBr,vB);
    x1.g = dot(unity_SHBg,vB);
    x1.b = dot(unity_SHBb,vB);

    // Final (5th) quadratic (L2) polynomial
    half vC = normal.x*normal.x - normal.y*normal.y;
    x2 = unity_SHC.rgb * vC;

    return x1 + x2;
}
```

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%2010.png](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/Untitled%2010.png)

L = 2时的伴随勒让德多项式

```cpp
// normal should be normalized, w=1.0
// output in active color space
half3 ShadeSH9 (half4 normal)
{
    // Linear + constant polynomial terms
    half3 res = SHEvalLinearL0L1 (normal);

    // Quadratic polynomials
    res += SHEvalLinearL2 (normal);

#   ifdef UNITY_COLORSPACE_GAMMA
        res = LinearToGammaSpace (res);
#   endif

    return res;
}
```

# unity内置Light Probes的调用

![%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/ligfqRLdBH.gif](%E5%85%89%E7%85%A7%E6%8E%A2%E9%92%88%207d1ea6fdc16649b2927e2d5c0fe22825/ligfqRLdBH.gif)

在shader中我们是通过unity定义的half3 ShadeSH9(half4 normal)来调用Light Probes的，Light Probes照明使用的是一种叫球谐光照（Sphere Harmonic）的模拟，简称SH,因此在ShadeSH9函数需要一个世界坐标中的Normal来决定物体表面的光照。

首先我们在顶点输出结构定义一个参数SHLighting：

```cpp
fixed3 SHLighting : COLOR;
```

然后在顶点函数里为它赋值：

```cpp
float3 worldNormal = mul((float3x3)_Object2World, v.normal);//获得世界坐标中的normal

o.SHLighting= ShadeSH9(float4(worldNormal,1)) ;
```

整个Shader：

```cpp
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
```