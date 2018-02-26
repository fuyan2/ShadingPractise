attribute vec3 position; // Given vertex position in object space
attribute vec3 normal; // Given vertex normal in object space

uniform mat4 projection, modelview, normalMat; // Given scene transformation matrices

// These will be given to the fragment shader and interpolated automatically
varying vec3 normalInterp;
varying vec3 vertPos;
varying vec4 color;

uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;
uniform vec3 lightPos; // Light position

void main(){
  // Your solution should go here.
  // Only the ambient colour calculations h ave been provided as an example.
  vec4 vertPos4 = modelview * vec4(position, 1.0);
  gl_Position = projection * vertPos4;
  vec3 Ambient = Ka*ambientColor; 

  //Diffuse Reflection Calculation
  vec4 normal4 = normalMat * vec4(normal, 0.0);
  vec4 lightPos4 = vec4(lightPos, 1.0);
  vec4 lightDirect = normalize(lightPos4 - vertPos4);
  vec3 Diffuse = diffuseColor*Kd*max(0.0,dot(lightDirect,normal4));

  //Specular Reflection Calculation
  vec4 eyePos4 = vec4(0.0, 0.0, 0.0, 1.0);
  vec4 ViewDirect = normalize(vertPos4 - eyePos4);
  vec4 lightReflectDirect = reflect(lightDirect,normal4);
  vec3 Specular = specularColor*Ks*pow(max(0.0, dot(lightReflectDirect,ViewDirect)),shininessVal);
  
  //Output to Fragment Shader, Phong Illumination Formula
  color = vec4(Ambient+Diffuse+Specular, 1.0);
}
