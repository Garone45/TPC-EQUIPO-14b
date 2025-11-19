<%@ Page Title="Gestión de Proveedor" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProveedoresForms.aspx.cs" Inherits="Presentacion.ProveedoresForms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- No necesitamos scripts extra aquí por ahora -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- ScriptManager Proxy si fuera necesario, aunque Site.Master ya debe tener uno -->
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server" />

    <div class="max-w-4xl mx-auto">

        <!-- Encabezado -->
        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <asp:Label ID="lblTitulo" runat="server" Text="Agregar Nuevo Proveedor"
                    CssClass="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]"></asp:Label>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Complete los datos del proveedor.</p>
            </div>
        </div>

        <!-- Zona de Mensajes de Servidor (UpdatePanel) -->
        <asp:UpdatePanel ID="updMensajes" runat="server">
            <ContentTemplate>
                <div class="mb-4">
                    <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" class="p-4 rounded-lg block border"></asp:Label>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div class="lg:col-span-1 bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60">
            <div class="flex flex-col gap-5">
                
                <!-- FILA 1: Razón Social y Seudónimo -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Razón Social (*)</p>
                        <asp:TextBox ID="txtRazonSocial" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                            placeholder="Ej: Proveedor S.A."></asp:TextBox>
                        
                        <!-- Validación: Requerido -->
                        <asp:RequiredFieldValidator ID="rfvRazonSocial" runat="server"
                            ControlToValidate="txtRazonSocial" ErrorMessage="La Razón Social es requerida."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>

                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Seudónimo (Nombre Fantasía)</p>
                        <asp:TextBox ID="txtSeudonimo" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                            placeholder="Ej: El Proveedor"></asp:TextBox>
                    </label>
                </div>

                <!-- FILA 2: CUIT y Teléfono -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">CUIT (*)</p>
                        <asp:TextBox ID="txtCUIT" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                            placeholder="Ej: 30-12345678-9"></asp:TextBox>
                        
                        <!-- Validación: Requerido -->
                        <asp:RequiredFieldValidator ID="rfvCUIT" runat="server"
                            ControlToValidate="txtCUIT" ErrorMessage="El CUIT es requerido."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                        
                        <!-- Validación: Formato (Solo números y guiones) -->
                        <asp:RegularExpressionValidator ID="revCUIT" runat="server"
                            ControlToValidate="txtCUIT" ValidationExpression="^[0-9\-]{11,13}$"
                            ErrorMessage="Formato inválido. Solo números y guiones (Ej: 20-12345678-9)."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>

                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Teléfono</p>
                        <asp:TextBox ID="txtTelefono" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                            placeholder="Ej: 11-4444-5555"></asp:TextBox>
                        
                        <!-- Validación: Solo números, espacios, guiones o paréntesis -->
                        <asp:RegularExpressionValidator ID="revTelefono" runat="server"
                            ControlToValidate="txtTelefono" ValidationExpression="^[0-9\-\(\)\s]+$"
                            ErrorMessage="Solo números, espacios y guiones permitidos."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>
                </div>

                <!-- Email -->
                <label class="flex flex-col flex-1">
                    <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Email</p>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                        CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                        placeholder="ejemplo@proveedor.com"></asp:TextBox>
                    
                    <!-- Validación: Formato de Email -->
                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                        ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        ErrorMessage="Por favor ingrese un email válido."
                        CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                </label>

                <!-- Dirección -->
                <label class="flex flex-col flex-1">
                    <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Dirección</p>
                    <asp:TextBox ID="txtDireccion" runat="server"
                        CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                        placeholder="Ej: Av. Siempre Viva 123"></asp:TextBox>
                </label>

                <!-- Botones -->
                <div class="flex items-center justify-end gap-3 mt-4">
                    <asp:HyperLink ID="btnCancelar" runat="server" NavigateUrl="~/ProveedoresListados.aspx"
                        CssClass="flex min-w-[84px] cursor-pointer items-center justify-center rounded-lg h-10 px-4 bg-slate-200 text-slate-700 text-sm font-bold hover:bg-slate-300">
                        <span class="truncate">Cancelar</span>
                    </asp:HyperLink>
                    
                    <!-- IMPORTANTE: Quitamos CausesValidation="false" para que las validaciones funcionen -->
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar"
                        CssClass="flex min-w-[84px] cursor-pointer items-center justify-center rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold hover:bg-primary/90"
                        OnClick="btnGuardar_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>