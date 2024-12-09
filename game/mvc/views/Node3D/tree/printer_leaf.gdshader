shader_type spatial;

uniform sampler2D texture; // Texture principale (albedo)
uniform sampler2D alpha_texture; // Masque de transparence




void fragment() {
    // Récupère la couleur de la texture principale
    vec4 texColor = texture(texture, UV);
    // Récupère la couleur du masque de transparence
    vec4 maskColor = texture(alpha_texture, UV);

    // Multiplie l'alpha de la texture par la valeur rouge du masque
    texColor.a *= maskColor.r;  // Utilise la composante rouge du masque pour l'alpha

    // Si l'alpha est trop faible, on rejette le fragment (optionnel)
    if (texColor.a < 0.1) {
        discard;  // Cette ligne supprime les pixels avec une transparence trop faible
    }

    // Applique la couleur de la texture et l'alpha modifié
    ALBEDO = vec3(1, 0.45, 0.75)*0.8;//texColor.rgb;
    ALPHA = texColor.a;
}
