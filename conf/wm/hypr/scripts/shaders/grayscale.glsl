#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);

    vec3 adjustedColor = vec3(
        0.2989 * color.r
        + 0.5870 * color.g
        + 0.1140 * color.b
    );
    fragColor = vec4(adjustedColor, color.a);
}
