#define RADIUS  7
#define KERNEL_SIZE (RADIUS * 2 + 1)

//-----------------------------------------------------------------------------
// Globals.
//-----------------------------------------------------------------------------

float weights[KERNEL_SIZE];
float2 offsets[KERNEL_SIZE];
bool invert = false;

//-----------------------------------------------------------------------------
// Textures.
//-----------------------------------------------------------------------------

sampler colorMap : register(s0);
sampler mask : register(s1);

//-----------------------------------------------------------------------------
// Pixel Shaders.
//-----------------------------------------------------------------------------

float4 PS_GaussianBlur(float2 texCoord : TEXCOORD) : COLOR0
{
	float4 maskColor = tex2D(mask, texCoord);

	if (invert == true)
		maskColor.a = 1 - maskColor.a;

    float4 color = float4(0.0f, 0.0f, 0.0f, 0.0f);
    
	for (int i = 0; i < KERNEL_SIZE; ++i)
		color += tex2D(colorMap, texCoord + (offsets[i] * maskColor.a)) * weights[i];
    return color;
}

//-----------------------------------------------------------------------------
// Techniques.
//-----------------------------------------------------------------------------

technique GaussianBlur
{
    pass
    {
        PixelShader = compile ps_2_0 PS_GaussianBlur();
    }
}
