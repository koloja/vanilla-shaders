// I lowkey forgot what this does, I worked on this resource pack like 6 months ago :sob:

#version 150

// Can't moj_import in things used during startup, when resource packs don't exist.
// This is a copy of dynamicimports.glsl
layout(std140) uniform DynamicTransforms
{
    mat4 ModelViewMat;
    vec4 ColorModulator;
    vec3 ModelOffset;
    mat4 TextureMat;
    float LineWidth;
};

uniform sampler2D Sampler0;

in vec2 texCoord0;
in vec4 vertexColor;

out vec4 fragColor;

void main()
{
    vec4 color = texture(Sampler0, texCoord0) * vertexColor;
    if (color.a == 0.0) discard;
    if (color.a > 0.0 && color.r > 0.99 && color.g > 0.99 && color.b > 0.99 && color.a < 0.6) discard;
    fragColor = color * ColorModulator;
}