// This is for the scoreboard only. (Or atleast I only tested it with the scoreboard)

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

const float PADDING = 12.0;
const float LINE_HEIGHT = 10.0;

vec4 indexTocolor(float index, float alpha) {
    if (index == 0.00) return vec4(1.000, 1.000, 1.000, alpha); // #FFFFFF
    if (index == 1.00) return vec4(0.000, 0.000, 0.000, alpha); // #000000
    if (index == 2.00) return vec4(0.502, 0.502, 0.502, alpha); // #808080
    if (index == 3.00) return vec4(0.251, 0.251, 0.251, alpha); // #404040
    if (index == 4.00) return vec4(0.627, 0.627, 0.627, alpha); // #A0A0A0
    if (index == 5.00) return vec4(0.729, 0.729, 0.729, alpha); // #BABABA
    if (index == 6.00) return vec4(1.000, 0.000, 0.000, alpha); // #FF0000
    if (index == 7.00) return vec4(0.875, 0.286, 0.314, alpha); // #DF4950
    if (index == 8.00) return vec4(0.000, 1.000, 0.000, alpha); // #00FF00
    if (index == 9.00) return vec4(0.000, 0.000, 1.000, alpha); // #0000FF
    if (index == 10.0) return vec4(1.000, 1.000, 0.000, alpha); // #FFFF00
    if (index == 11.0) return vec4(1.000, 1.000, 0.333, alpha); // #FFFF55
    if (index == 12.0) return vec4(0.310, 0.000, 0.310, alpha); // #4F004F
    if (index == 13.0) return vec4(1.000, 0.800, 0.800, alpha); // #FFCCCC
    if (index == 14.0) return vec4(0.878, 0.878, 0.878, alpha); // #E0E0E0
    if (index == 15.0) return vec4(1.000, 1.000, 1.000, alpha); // #FFFFFF XL
    return vec4(1.000, 1.000, 1.000, alpha);
}

void main() {
    vec3 pos = Position;
    vec4 col = Color * texelFetch(Sampler2, UV2 / 16, 0);

    float r = floor(Color.r * 255.0 + 0.5);
    float g = floor(Color.g * 255.0 + 0.5);
    float b = floor(Color.b * 255.0 + 0.5);

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    if ((b >= 201.0 && b <= 210.0 && !(abs(Color.r - Color.g) < 0.01 && abs(Color.g - Color.b) < 0.01))) {
        float colorIndex = r - floor(r / 16.0) * 16.0;
        float yIndex = floor(r / 16.0);
        float textWidth = g * 2.0;
        float anchor = b - 201.0;
        float yOffsetNDC = (yIndex * LINE_HEIGHT / ScreenSize.y) * gl_Position.w * 1.0;

        col = indexTocolor(colorIndex, Color.a);

        float naturalX = 0.965;
        float naturalY = 0.016;
        float paddingX = (PADDING / ScreenSize.x) * gl_Position.w * 2.0;
        float paddingY = (PADDING / ScreenSize.y) * gl_Position.w * 2.0;
        float topOffset = (1.0 - naturalY) * gl_Position.w - paddingY;
        float bottomOffset = (1.0 - naturalY) * gl_Position.w - paddingY;
        float leftOffset = (naturalX + 1.0) * gl_Position.w - paddingX;
        float rightPadding = paddingX;
        float halfTextNDC = (textWidth / ScreenSize.x) * gl_Position.w;
        float centerOffset = (naturalX * gl_Position.w) + halfTextNDC + (textWidth / ScreenSize.x) * gl_Position.w;

        if (anchor == 1.0) {        // TOP_LEFT
            gl_Position.x -= leftOffset;
            gl_Position.y += topOffset - yOffsetNDC;
        } else if (anchor == 2.0) { // TOP_CENTER
            gl_Position.x -= centerOffset;
            gl_Position.y += topOffset - yOffsetNDC;
        } else if (anchor == 3.0) { // TOP_RIGHT
            gl_Position.x -= rightPadding;
            gl_Position.y += topOffset - yOffsetNDC;
        } else if (anchor == 4.0) { // MIDDLE_LEFT
            gl_Position.x -= leftOffset;
            gl_Position.y -= yOffsetNDC;
        } else if (anchor == 5.0) { // CENTER
            gl_Position.x -= centerOffset - ((textWidth * 0.75) / ScreenSize.x) * gl_Position.w * 2.0;
            gl_Position.y -= yOffsetNDC;
        } else if (anchor == 6.0) { // MIDDLE_RIGHT
            gl_Position.x -= rightPadding;
            gl_Position.y -= yOffsetNDC;
        } else if (anchor == 7.0) { // BOTTOM_LEFT
            gl_Position.x -= leftOffset;
            gl_Position.y -= bottomOffset + yOffsetNDC;
        } else if (anchor == 8.0) { // BOTTOM_CENTER
            gl_Position.x -= centerOffset;
            gl_Position.y -= bottomOffset + yOffsetNDC;
        } else if (anchor == 9.0) { // BOTTOM_RIGHT
            gl_Position.x -= rightPadding;
            gl_Position.y -= bottomOffset + yOffsetNDC;
        }

        // make XL if XL colors
        if (colorIndex == 15.0) {
            vec2 pivot;
            float w = gl_Position.w;

            if (anchor == 1.0) pivot = vec2(-w,  w);        // TOP_LEFT
            else if (anchor == 2.0) pivot = vec2(0.0, w);   // TOP_CENTER
            else if (anchor == 3.0) pivot = vec2( w,  w);   // TOP_RIGHT
            else if (anchor == 4.0) pivot = vec2(-w, 0.0);  // MIDDLE_LEFT
            else if (anchor == 5.0) pivot = vec2(0.0, 0.0); // CENTER
            else if (anchor == 6.0) pivot = vec2( w, 0.0);  // MIDDLE_RIGHT
            else if (anchor == 7.0) pivot = vec2(-w, -w);   // BOTTOM_LEFT
            else if (anchor == 8.0) pivot = vec2(0.0, -w);  // BOTTOM_CENTER
            else if (anchor == 9.0) pivot = vec2( w, -w);   // BOTTOM_RIGHT

            gl_Position.xy = pivot + (gl_Position.xy - pivot) * 2.0;
        }

    }

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = col;
    texCoord0 = UV0;
}