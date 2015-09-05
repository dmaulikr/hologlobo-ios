#ifdef GL_ES
precision lowp float;
#endif

varying lowp vec4 DestinationColor;

varying lowp vec2 TexCoordOut;
uniform sampler2D Texture;

void main(void) {
    
    lowp vec4 color = DestinationColor * texture2D(Texture, TexCoordOut);
    gl_FragColor = color;
}
