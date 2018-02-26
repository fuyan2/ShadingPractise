precision mediump float; // It is required to set a floating point precision in all fragment shaders.

// Interpolated values from vertex shader
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position

uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;
uniform vec3 lightPos; // Light position

void main() {
  // Your solution should go here.
  // Only the ambient colour calculations have been provided as an example.
  vec4 position4 = vec4(vertPos, 1.0);

  //Ambient Color Calculation
  vec3 Ambient = Ka*ambientColor; 

  //Diffuse Color Calculation
  vec4 normal4 = vec4(normalInterp, 0.0);
  vec4 lightPos4 = vec4(lightPos, 1.0);
  vec4 lightDirect = normalize(lightPos4 - position4);
  vec3 Diffuse = diffuseColor*Kd*max(0.0,dot(lightDirect,normal4));

  //Specular Color Calculation
  vec4 eyePos4 = vec4(0.0, 0.0, 0.0, 1.0);
  vec4 ViewDirect = normalize(position4 - eyePos4);
  vec4 lightReflectDirect = normalize(reflect(lightDirect,normal4));
  vec3 Specular = specularColor*Ks*pow(max(0.0,dot(lightReflectDirect,ViewDirect)),shininessVal);

  //Combine three colors together
  gl_FragColor = vec4(Ambient+Diffuse+Specular, 1.0);
}
