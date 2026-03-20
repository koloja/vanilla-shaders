#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:globals.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
flat out int trigger;

void main() {
    vec3 pos = Position;
    vec4 color = Color;
    int id = 0;
    bool anchored = false;

    if (pos.y >= 5000.0) {
        pos.y -= 5000.0;
        color.a = 1.0;
        id = 4;
    } else if (pos.y >= 4000.0) {
        pos.y -= 4000.0;
        color.a = 1.0;
        id = 3;
    } else if (pos.y >= 3000.0) {
        pos.y -= 3000.0;
        color.a = 1.0;
        id = 2;
    } else if (pos.y >= 2000.0) {
        pos.y -= 2000.0;
        color.a = 1.0;
        id = 1;
    }

    vec4 worldPos = ModelViewMat * vec4(pos, 1.0);
    gl_Position = ProjMat * worldPos;

    float x = 16.0;
    float y = 6.0;

    if (id == 1) {
        // top left
        float halfTextWidthClip = (0.0 / ScreenSize.x) * gl_Position.w * 2.0;
        float nudgeX = x / ScreenSize.x * 2.0 * gl_Position.w;
        float nudgeY = y / ScreenSize.y * 2.0 * gl_Position.w;

        gl_Position.x -= gl_Position.w;
        gl_Position.x += halfTextWidthClip;
        gl_Position.x += nudgeX;
        gl_Position.y += nudgeY;
    } else if (id == 2) {
        // top right
        float halfTextWidthClip = (0.0 / ScreenSize.x) * gl_Position.w * 2.0;
        float offsetY = 38.0;
        float nudgeX = x / ScreenSize.x * 2.0 * gl_Position.w;
        float nudgeY = (y + offsetY) / ScreenSize.y * 2.0 * gl_Position.w;

        gl_Position.x += gl_Position.w;
        gl_Position.x -= halfTextWidthClip;
        gl_Position.x -= nudgeX;
        gl_Position.y += nudgeY;
    } else if (id == 3) {
        // bottom left
        float halfTextWidthClip = (0.0 / ScreenSize.x) * gl_Position.w * 2.0;
        float nudgeX = x / ScreenSize.x * 2.0 * gl_Position.w;
        float nudgeYUp = y / ScreenSize.y * 2.0 * gl_Position.w;
        float nudgeYDown = (97.0 / 100.0) * 2.0 * gl_Position.w;

        gl_Position.x -= gl_Position.w;
        gl_Position.x += halfTextWidthClip;
        gl_Position.x += nudgeX;
        gl_Position.y += nudgeYUp;
        gl_Position.y -= nudgeYDown;
    } else if (id == 4) {
        // bottom right
        float halfTextWidthClip = (0.0 / ScreenSize.x) * gl_Position.w * 2.0;
        float nudgeX = x / ScreenSize.x * 2.0 * gl_Position.w;
        float nudgeYUp = y / ScreenSize.y * 2.0 * gl_Position.w;
        float nudgeYDown = (97.0 / 100.0) * 2.0 * gl_Position.w;

        gl_Position.x += gl_Position.w;
        gl_Position.x -= halfTextWidthClip;
        gl_Position.x -= nudgeX;
        gl_Position.y += nudgeYUp;
        gl_Position.y -= nudgeYDown;
    }

    trigger = id;
    sphericalVertexDistance = fog_spherical_distance(pos);
    cylindricalVertexDistance = fog_cylindrical_distance(pos);
    vertexColor = color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
}