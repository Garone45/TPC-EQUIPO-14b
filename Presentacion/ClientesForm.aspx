<%@ Page Title="Gestión de Clientes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ClientesForm.aspx.cs" Inherits="Presentacion.ClientesForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server" />

    <div class="max-w-2xl mx-auto">
        
        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <asp:Label ID="lblTitulo" runat="server" Text="Nuevo Cliente" 
                    CssClass="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]"></asp:Label>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Complete los datos personales.</p>
            </div>
        </div>

        <asp:UpdatePanel ID="updMensajes" runat="server">
            <ContentTemplate>
                <div class="mb-4">
                    <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" class="p-4 rounded-lg block border"></asp:Label>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div class="bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60">
            <div class="flex flex-col gap-5">
                
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Nombre(s) *</span>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="Ej: Juan"></asp:TextBox>
                        
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNombre"
                            ErrorMessage="Requerido." CssClass="text-red-500 text-xs font-bold mt-1" Display="Dynamic" />
                    </label>

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Apellido(s) *</span>
                        <asp:TextBox ID="txtApellido" runat="server" CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="Ej: Pérez"></asp:TextBox>
                        
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtApellido"
                            ErrorMessage="Requerido." CssClass="text-red-500 text-xs font-bold mt-1" Display="Dynamic" />
                    </label>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">DNI / Cédula *</span>
                        <asp:TextBox ID="txtDni" runat="server" CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="Ej: 30123456"></asp:TextBox>
                        
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDni"
                            ErrorMessage="Requerido." CssClass="text-red-500 text-xs font-bold mt-1" Display="Dynamic" />
                        
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtDni"
                            ValidationExpression="^[a-zA-Z0-9\-]+$"
                            ErrorMessage="Solo números, letras o guiones."
                            CssClass="text-red-500 text-xs font-bold mt-1" Display="Dynamic" />
                    </label>

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Teléfono</span>
                        <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="Ej: 11 4444-5555"></asp:TextBox>
                        
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtTelefono"
                            ValidationExpression="^[0-9\-\+\s]+$"
                            ErrorMessage="Formato inválido (use números, guiones o +)."
                            CssClass="text-red-500 text-xs font-bold mt-1" Display="Dynamic" />
                    </label>
                </div>

                <label class="flex flex-col">
                    <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Correo Electrónico *</span>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="cliente@mail.com"></asp:TextBox>
                    
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Requerido." CssClass="text-red-500 text-xs font-bold mt-1" Display="Dynamic" />
                    
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        ErrorMessage="Ingrese un email válido."
                        CssClass="text-red-500 text-xs font-bold mt-1" Display="Dynamic" />
                </label>

                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <label class="flex flex-col flex-1 sm:col-span-2">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Dirección (Calle)</span>
                        <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="Ej: Av. Siempre Viva"></asp:TextBox>
                    </label>

                    <label class="flex flex-col flex-1 sm:col-span-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Altura</span>
                        <asp:TextBox ID="txtAltura" runat="server" CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="123"></asp:TextBox>
                    </label>
                </div>

                <label class="flex flex-col">
                    <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Localidad</span>
                    <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="Ej: CABA"></asp:TextBox>
                </label>

                <div class="flex justify-end gap-4 mt-6">
                    <asp:HyperLink ID="btnCancelar" runat="server" NavigateUrl="~/ClientesListado.aspx"
                        CssClass="px-4 py-2 rounded-lg bg-slate-200 text-slate-700 text-sm font-bold hover:bg-slate-300">
                        Cancelar
                    </asp:HyperLink>

                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" OnClick="btnGuardar_Click"
                        CssClass="px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold hover:bg-primary/90 cursor-pointer" />
                </div>

            </div>
        </div>
    </div>
</asp:Content>