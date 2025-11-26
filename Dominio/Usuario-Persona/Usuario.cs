namespace Dominio.Usuario_Persona
{
    public enum TipoUsuario
    {
        ADMIN = 1,
        VENDEDOR = 2
    }

    public class Usuario
    {
        public int IDUsuario { get; set; }
        public string NombreUsuario { get; set; } // Ojo: En SQL se llama NombreUser
        public string Contraseña { get; set; }
        public bool Activo { get; set; }
        public TipoUsuario TipoUsuario { get; set; }

     
        public Usuario()
        {
        }
      

        public Usuario(string NombreUser, string Contrasena, bool ADMIN)
        {
            NombreUsuario = NombreUser;
            Contraseña = Contrasena;
            TipoUsuario = ADMIN ? TipoUsuario.ADMIN : TipoUsuario.VENDEDOR;
        }
    }
}