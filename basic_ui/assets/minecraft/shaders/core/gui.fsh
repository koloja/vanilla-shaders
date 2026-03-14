#version 330

layout(std140) uniform DynamicTransforms {
    mat4 ModelViewMat;
    vec4 ColorModulator;
    vec3 ModelOffset;
    mat4 TextureMat;
};

in vec4 vertexColor;

out vec4 fragColor;

void main() {
    vec4 color = vertexColor;
    if (color.a == 0.0) { discard; }

    vec4 raw = color / ColorModulator;
    if (raw.r < 0.01 && raw.g < 0.01 && raw.b < 0.01 && abs(raw.a - 0.298) < 0.05) { discard; }       // scoreboard background
    if (color.r < 0.01 && color.g < 0.01 && color.b < 0.01 && abs(color.a - 0.4) < 0.05) { discard; } // scoreboard header

    fragColor = color * ColorModulator;
}