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
  // Your solution should go here
  // Only the ambient colour calculations have been provided as an example.
  vec4 position4 = vec4(vertPos, 1.0);
  vec3 Ambient = Ka*ambientColor; 

  //Diffuse needed variables
  vec4 normal4 = vec4(normalInterp, 0.0);
  vec4 lightPos4 = vec4(lightPos, 1.0);
  vec4 lightDirect = normalize(lightPos4 - position4);
  vec3 Diffuse;
  
  //Discrete Diffuse color
  if (dot(lightDirect, normal4) > 0.75)
  {
  	Diffuse = diffuseColor*Kd*0.75;
  }else if (dot(lightDirect, normal4) > 0.5)
  {
  	Diffuse = diffuseColor*Kd*0.5;
  }else if (dot(lightDirect, normal4) > 0.25)
  {
  	Diffuse = diffuseColor*Kd*0.25;
  }else{
  	Diffuse = diffuseColor*0.0;
  }

  //Specular needed variables
  vec4 eyePos4 = vec4(0.0, 0.0, 0.0, 1.0);
  vec4 ViewDirect = normalize(position4 - eyePos4);
  vec4 lightReflectDirect = normalize(reflect(lightDirect,normal4));
  vec3 Specular;
  
  //Dicrete Specular Color
  if (dot(lightReflectDirect, ViewDirect) > 0.99)
  {
  	Specular = specularColor*Ks*pow(1.0,shininessVal);
  }else{
  	Specular = specularColor*Ks*pow(0.0,shininessVal);
  }

  //Combine three colors together
  gl_FragColor = vec4(Ambient+Diffuse+Specular, 1.0);
}