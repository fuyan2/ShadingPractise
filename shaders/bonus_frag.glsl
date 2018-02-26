// Fragment shader template for the bonus question

precision mediump float; // It is required to set a floating point precision in all fragment shaders.

// Interpolated values from vertex shader
// NOTE: You may need to edit this section to add additional variables
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // Interpolated view vector

// uniform values remain the same across the scene
// NOTE: You may need to edit this section to add additional variables
uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform vec3 lightPos; // Light position

uniform sampler2D uSampler;	// 2D sampler for the earth texture
uniform samplerCube envTexSampler;	// cube sampler for the environment map

void main() {
  // Your solution should go here.
  // Only the ambient colour calculations have been provided as an example.
  vec3 Ambient = Ka*ambientColor; 

  //Diffuse
  vec3 lightDirect = normalize(lightPos - vertPos);
  float LdotN = max(0.0, dot(lightDirect,normalInterp));
  float NdotV = max(0.0, dot(normalInterp, viewVec));
  vec3 Diffuse = diffuseColor*Kd*LdotN;
  
  //Cook Torrance Specular, calculate needed variables first
  float rough = 0.06;
  float F0 = 0.95;
  float VdotN = max(dot(viewVec, normalInterp), 0.0);
  //Calculate H
  vec3 H = normalize(lightDirect + viewVec);
  float NdotH = max(0.0, dot(normalInterp, H));
  float VdotH = max(0.0, dot(viewVec, H));
  float pi = 3.1415926;

  //Calculate Fresnel Equation using Schlick's approximation//Fresnel term
  float F = F0 + (1.0 - F0) * pow(1.0 - VdotN, 5.0);   

  //Calculate Geometric term
  float G = min(1.0, min((2.0 * NdotH * VdotN/ VdotH), (2.0 * NdotH * LdotN/ VdotH)));

  //Calculate Beckmann Distribution
  float sqcosAlpha = NdotH * NdotH;
  float sqtanAlpha = (sqcosAlpha - 1.0) / sqcosAlpha;
  float numerator = exp(sqtanAlpha / (rough * rough));
  float denomintor = pi * rough * rough * sqcosAlpha * sqcosAlpha;
  float D = numerator / denomintor;

  //Calculate the final value with G, F, D
  float Kspec = max(0.001, G * F * D / max(pi * VdotN * LdotN, 0.000001));
  vec3 Specular = Kspec * specularColor;

  //Combine three colors together
  gl_FragColor = vec4(Ambient+Diffuse+Specular, 1.0);
}
