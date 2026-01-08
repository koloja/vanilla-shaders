#version 330 core

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

vec2[4] corners = vec2[](vec2(0, -1), vec2(0, 0), vec2(1, 0), vec2(1, -1));

void main()
{
    texCoord0 = UV0;
    vec4 color = Color;
    vec3 pos = Position;

    ivec4 icol = ivec4(round(Color * 255));
    ivec4 marker = ivec4(texture(Sampler0, UV0) * 255);
    vec2 center = vec2(
        trunc((ceil(2.0 / ProjMat[0][0] - 0.001) - 176.0) / 2.0) + 88.0,
        trunc((ceil(2.0 / (-ProjMat[1][1]) - 0.001) - 222.0) / 2.0) + 111.0
    );

    if (marker == ivec4(118, 215, 118, 255))
    {
        color = vec4(1.0);
        vec2 offset = corners[gl_VertexID % 4] * 18.0;
        float scale = float(max(icol.b, 1));
        offset *= scale;
        vec2 baseOffset = vec2(icol.r, icol.g) - vec2(127.0, 127.0) - vec2(27.0, -12.0);
        offset += baseOffset;
        pos = vec3(floor(center + offset), pos.z -= 2.0);
    }

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = color * texelFetch(Sampler2, UV2 / 16, 0);
}