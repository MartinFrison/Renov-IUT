shader_type spatial;

uniform sampler2D texture;       // Texture principale (albedo)
uniform sampler2D normal_map;    // Normal map
uniform sampler2D roughness_map; // Roughness map
uniform sampler2D metalness_map; // Metalness map

uniform sampler2D crack;         // Texture de fissure
uniform float crack_intensity : hint_range(0.0, 1.0) = 1.0; // Intensité des fissures


void fragment() 
{
    // Récupération des couleurs des textures
    vec4 texColor = texture(texture, UV);      // Couleur de la texture principale (Albedo)
    vec4 crackColor = texture(crack, UV);      // Texture de fissures en noir et blanc
    
	// Applique les fissures à la texture principale
	crackColor.r = max(crackColor.r, (1.0-crack_intensity)); // Réduit l'intensité des fissures
	vec3 albedo = texColor.rgb * crackColor.r; // Applique uniquement la composante en niveaux de gris des fissures

    
    // Charge les autres propriétés du matériau
    vec3 normal = texture(normal_map, UV).rgb * 2.0 - 1.0; // Convertit en espace tangent
    float roughness = texture(roughness_map, UV).r;        // Roughness
    float metalness = texture(metalness_map, UV).r;        // Metalness

    // Sorties du shader
    ALBEDO = albedo;       // Couleur finale avec fissures
    NORMAL = normalize(normal); // Normal map
    ROUGHNESS = roughness; // Rugosité
    METALLIC = metalness;  // Métallicité
    ALPHA = texColor.a;    // Alpha inchangé
}
