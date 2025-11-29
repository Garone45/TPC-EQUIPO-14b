<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecuperarPassword.aspx.cs" Inherits="Presentacion.RecuperarPassword" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Recuperar Contraseña</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-slate-50 dark:bg-[#101922] min-h-screen flex items-center justify-center p-4">
    <form id="form1" runat="server">
        
        <div class="w-full max-w-md bg-white dark:bg-[#1e293b] rounded-2xl shadow-xl border border-slate-200 dark:border-slate-700 p-8">
            
            <div class="text-center mb-6">
                <div class="inline-flex items-center justify-center w-14 h-14 rounded-full bg-blue-100 dark:bg-blue-900/30 text-[#1173d4] mb-4">
                    <span class="material-symbols-outlined text-3xl">lock_reset</span>
                </div>
                <h2 class="text-2xl font-bold text-slate-900 dark:text-white">Recuperar Contraseña</h2>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2">
                    Ingresa tu correo electrónico y te enviaremos las instrucciones.
                </p>
            </div>

            <div class="flex flex-col gap-4">
                
                <div>
                    <label class="block text-sm font-bold text-slate-700 dark:text-slate-300 mb-1 ml-1">Email</label>
                    <div class="relative">
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" 
                            CssClass="w-full px-4 py-3 bg-slate-50 dark:bg-slate-900 border border-slate-300 dark:border-slate-600 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-[#1173d4] transition-all" 
                            placeholder="ejemplo@correo.com"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ErrorMessage="Ingresa tu email." ControlToValidate="txtEmail" runat="server" Display="Dynamic" CssClass="text-xs text-red-500 font-bold mt-1 ml-1" />
                    <asp:RegularExpressionValidator ErrorMessage="Formato de email inválido." ControlToValidate="txtEmail" runat="server" Display="Dynamic" CssClass="text-xs text-red-500 font-bold mt-1 ml-1" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
                </div>

                <asp:Button ID="btnRecuperar" runat="server" Text="Enviar Instrucciones" OnClick="btnRecuperar_Click"
                    CssClass="w-full py-3 px-4 bg-[#1173d4] hover:bg-blue-700 text-white font-bold rounded-xl shadow-lg transition-all cursor-pointer mt-2" />
                
                <div class="text-center mt-4">
                    <a href="Login.aspx" class="text-sm text-slate-500 hover:text-[#1173d4] font-medium transition-colors">
                        Volver al Login
                    </a>
                </div>

                <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" CssClass="text-center text-sm font-bold p-3 rounded-xl mt-2 block"></asp:Label>

            </div>
        </div>

    </form>
</body>
</html>