#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

const bool DEBUG_MARKER = false; // not needed but good for development

void main()
{
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) discard;

    if (all(lessThan(abs(color.rgb - vec3(0.4627, 0.8431, 0.4627)), vec3(0.01))))
    {
        if (DEBUG_MARKER) fragColor = vec4(1.0, 0.0, 0.0, 1.0);
        else fragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
    else
    {
        fragColor = apply_fog(
            color,
            sphericalVertexDistance,
            cylindricalVertexDistance,
            FogEnvironmentalStart,
            FogEnvironmentalEnd,
            FogRenderDistanceStart,
            FogRenderDistanceEnd,
            FogColor
        );
    }
}