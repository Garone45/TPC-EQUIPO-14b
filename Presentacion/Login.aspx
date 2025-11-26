<%@ Page Title="Iniciar Sesión" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Presentacion.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    </asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="fixed inset-0 z-50 flex items-center justify-center bg-gradient-to-br from-slate-900 via-blue-900 to-slate-900">
        
        <div class="w-full max-w-md bg-white dark:bg-[#1e293b] rounded-2xl shadow-2xl border border-slate-200 dark:border-slate-700 p-8 transform transition-all hover:scale-[1.01]">
            
            <div class="text-center mb-8">
                <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-blue-100 dark:bg-blue-900/30 mb-4 text-primary">
                   <span class="material-symbols-outlined text-4xl">lock</span>
                </div>
                <h2 class="text-3xl font-extrabold text-slate-900 dark:text-white tracking-tight">Bienvenido</h2>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2">Sistema de Gestión TPC</p>
            </div>

            <div class="flex flex-col gap-5">
                
                <div>
                    <label class="block text-sm font-bold text-slate-700 dark:text-slate-300 mb-1 ml-1">Usuario</label>
                    <div class="relative group">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <span class="material-symbols-outlined text-slate-400 group-focus-within:text-primary transition-colors text-[20px]">person</span>
                        </div>
                        <asp:TextBox ID="txtUsuario" runat="server" CssClass="w-full pl-10 pr-4 py-3 bg-slate-50 dark:bg-slate-900 border border-slate-300 dark:border-slate-600 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all shadow-sm" placeholder="Ingresa tu usuario"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ErrorMessage="El usuario es requerido." ControlToValidate="txtUsuario" runat="server" Display="Dynamic" CssClass="text-xs text-red-500 font-bold mt-1 ml-1 block" />
                </div>

                <div>
                    <label class="block text-sm font-bold text-slate-700 dark:text-slate-300 mb-1 ml-1">Contraseña</label>
                    <div class="relative group">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <span class="material-symbols-outlined text-slate-400 group-focus-within:text-primary transition-colors text-[20px]">key</span>
                        </div>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="w-full pl-10 pr-4 py-3 bg-slate-50 dark:bg-slate-900 border border-slate-300 dark:border-slate-600 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all shadow-sm" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ErrorMessage="La contraseña es requerida." ControlToValidate="txtPassword" runat="server" Display="Dynamic" CssClass="text-xs text-red-500 font-bold mt-1 ml-1 block" />
                </div>

                <div class="mt-4">
                    <asp:Button ID="btnLogin" runat="server" Text="INGRESAR" OnClick="btnLogin_Click" 
                        CssClass="w-full py-3.5 px-4 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-bold rounded-xl shadow-lg hover:shadow-blue-500/30 transform hover:-translate-y-0.5 transition-all duration-200 cursor-pointer tracking-wide" />
                </div>

                <asp:Label ID="lblError" runat="server" Text="" CssClass="text-center text-sm text-red-500 font-bold p-3 bg-red-50 dark:bg-red-900/20 rounded-xl border border-red-100 dark:border-red-900/50 animate-pulse" Visible="false"></asp:Label>
            </div>
            
            <div class="mt-8 text-center border-t border-slate-100 dark:border-slate-700 pt-4">
                <p class="text-xs text-slate-400">© 2025 Equipo 14b - Todos los derechos reservados</p>
            </div>

        </div>
    </div>

</asp:Content>