precision mediump float; // It is required to set a floating point precision in all fragment shaders.

// Interpolated values from vertex shader
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // View vector (eye to fragment)

uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
// HINT: Use the environment map as the ambient color
uniform vec3 diffuseColor;
uniform vec3 specularColor;
uniform vec3 lightPos; // Light position

uniform samplerCube envTexSampler; // A GLSL sampler represents a single texture. A samplerCube can be used to sample a cubemap texture.

void main() {
  // Your solution should go here.
  vec4 position4 = vec4(vertPos, 1.0);
  vec4 normal4 = normalize(vec4(normalInterp, 0.0));

  //Diffuse Color Calculation
  vec4 lightPos4 = vec4(lightPos, 1.0);
  vec4 lightDirect = normalize(lightPos4 - position4);
  vec3 Diffuse = diffuseColor*Kd*max(0.0,dot(lightDirect,normal4));

  //Specular Color Calculation
  vec4 ViewDirect = normalize(vec4(viewVec, 0.0));
  vec4 lightReflectDirect = normalize(reflect(lightDirect,normal4));
  vec3 Specular = specularColor*Ks*pow(max(0.0,dot(lightReflectDirect,ViewDirect)),shininessVal);

  //Environment mapping for Ambient color by using reflected view direct
  vec3 reflectViewDirect = normalize(reflect(viewVec, normalInterp));
  vec4 ambientColor = textureCube(envTexSampler, reflectViewDirect);
  vec3 Ambient = Ka*ambientColor.xyz; 

  //Combine three colors together
  gl_FragColor = vec4(Ambient + Diffuse + Specular, 1.0);
}
