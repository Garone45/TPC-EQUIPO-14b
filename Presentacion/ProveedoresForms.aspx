<%@ Page Title="Gestión de Proveedor" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProveedoresForms.aspx.cs" Inherits="Presentacion.ProveedoresForms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server" />

    <div class="max-w-4xl mx-auto">

        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <asp:Label ID="lblTitulo" runat="server" Text="Agregar Nuevo Proveedor"
                    CssClass="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]"></asp:Label>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Complete los datos del proveedor.</p>
            </div>
        </div>

        <asp:UpdatePanel ID="updMensajes" runat="server">
            <ContentTemplate>
                <div class="mb-4">
                    <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" class="p-4 rounded-lg block border"></asp:Label>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div class="lg:col-span-1 bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60">
            <div class="flex flex-col gap-5">
                
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Razón Social *</span>
                        <asp:TextBox ID="txtRazonSocial" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                            placeholder="Ej: Proveedor S.A."></asp:TextBox>
                        
                        <asp:RequiredFieldValidator ID="rfvRazonSocial" runat="server"
                            ControlToValidate="txtRazonSocial" ErrorMessage="La Razón Social es requerida."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Seudónimo (Fantasía)</span>
                        <asp:TextBox ID="txtSeudonimo" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                            placeholder="Ej: El Proveedor"></asp:TextBox>
                    </label>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">CUIT (Solo números) *</span>
                        <asp:TextBox ID="txtCUIT" runat="server" TextMode="Number"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                            placeholder="Ej: 30123456789"></asp:TextBox>
                        
                        <asp:RequiredFieldValidator ID="rfvCUIT" runat="server"
                            ControlToValidate="txtCUIT" ErrorMessage="El CUIT es requerido."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                        
                        <asp:RegularExpressionValidator ID="revCUIT" runat="server"
                            ControlToValidate="txtCUIT" ValidationExpression="^[0-9]+$"
                            ErrorMessage="Solo números permitidos (sin guiones)."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Teléfono (Solo números) *</span>
                        <asp:TextBox ID="txtTelefono" runat="server" TextMode="Number"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                            placeholder="Ej: 1144445555"></asp:TextBox>
                        
                        <asp:RequiredFieldValidator ID="rfvTelefono" runat="server"
                            ControlToValidate="txtTelefono" ErrorMessage="El teléfono es requerido."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />

                        <asp:RegularExpressionValidator ID="revTelefono" runat="server"
                            ControlToValidate="txtTelefono" ValidationExpression="^[0-9]+$"
                            ErrorMessage="Solo números permitidos."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>
                </div>

                <label class="flex flex-col flex-1">
                    <span class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Email *</span>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                        CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                        placeholder="ejemplo@proveedor.com"></asp:TextBox>
                    
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                        ControlToValidate="txtEmail" ErrorMessage="El email es requerido."
                        CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />

                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                        ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        ErrorMessage="Formato de email inválido."
                        CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                </label>

                <label class="flex flex-col flex-1">
                    <span class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Dirección *</span>
                    <asp:TextBox ID="txtDireccion" runat="server"
                        CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 px-4 text-sm font-normal leading-normal"
                        placeholder="Ej: Av. Siempre Viva 123"></asp:TextBox>

                    <asp:RequiredFieldValidator ID="rfvDireccion" runat="server"
                        ControlToValidate="txtDireccion" ErrorMessage="La dirección es requerida."
                        CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                </label>

                <div class="flex items-center justify-end gap-3 mt-4">
                    <asp:HyperLink ID="btnCancelar" runat="server" NavigateUrl="~/ProveedoresListados.aspx"
                        CssClass="flex min-w-[84px] cursor-pointer items-center justify-center rounded-lg h-10 px-4 bg-slate-200 text-slate-700 text-sm font-bold hover:bg-slate-300">
                        <span class="truncate">Cancelar</span>
                    </asp:HyperLink>
                    
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar"
                        CssClass="flex min-w-[84px] cursor-pointer items-center justify-center rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold hover:bg-primary/90"
                        OnClick="btnGuardar_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>