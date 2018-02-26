attribute vec3 position; // Given vertex position in object space
attribute vec3 normal; // Given vertex normal in object space
attribute vec3 worldPosition; // Given vertex position in world space

uniform mat4 projection, modelview, normalMat; // Given scene transformation matrices

// These will be given to the fragment shader and interpolated automatically
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // Vector from the eye to the vertex
void main() {
  // Your solution should go here.
  //vertex position in camera space
  vec4 vertPos4 = modelview * vec4(position, 1.0);
  gl_Position = projection * vertPos4;
  vertPos = vertPos4.xyz;
  //Convert normal vector to view space and pass it into fragment shader
  normalInterp = (normalMat * vec4(normal, 1.0)).xyz;
  //vector point from vertex to eye
  viewVec = normalize((vertPos4 - vec4(0.0, 0.0, 0.0, 1.0)).xyz); 
}
