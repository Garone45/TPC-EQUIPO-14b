<%@ Page Title="Gestión de Proveedor" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProveedoresForm.aspx.cs" Inherits="Presentacion.ProveedoresForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-4xl mx-auto">

        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <asp:Label ID="lblTitulo" runat="server" Text="Agregar Nuevo Proveedor"
                    CssClass="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]"></asp:Label>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Complete los datos del proveedor.</p>
            </div>
        </div>

        <div class="lg:col-span-1 bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60">
            <div class="flex flex-col gap-5">
                
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Razón Social (*)</p>
                        <asp:TextBox ID="txtRazonSocial" runat="server"
                            CssClass="form-input flex w-full ... h-11"
                            placeholder="Ej: Proveedor S.A."></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvRazonSocial" runat="server"
                            ControlToValidate="txtRazonSocial" ErrorMessage="La Razón Social es requerida."
                            CssClass="text-red-500 text-xs mt-1" Display="Dynamic" />
                    </label>
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Seudónimo (Nombre Fantasía)</p>
                        <asp:TextBox ID="txtSeudonimo" runat="server"
                            CssClass="form-input flex w-full ... h-11"
                            placeholder="Ej: El Proveedor"></asp:TextBox>
                    </label>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">CUIT (*)</p>
                        <asp:TextBox ID="txtCUIT" runat="server"
                            CssClass="form-input flex w-full ... h-11"
                            placeholder="Ej: 30-12345678-9"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCUIT" runat="server"
                            ControlToValidate="txtCUIT" ErrorMessage="El CUIT es requerido."
                            CssClass="text-red-500 text-xs mt-1" Display="Dynamic" />
                    </label>
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Teléfono</p>
                        <asp:TextBox ID="txtTelefono" runat="server"
                            CssClass="form-input flex w-full ... h-11"
                            placeholder="Ej: 11-4444-5555"></asp:TextBox>
                    </label>
                </div>

                <label class="flex flex-col flex-1">
                    <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Email</p>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                        CssClass="form-input flex w-full ... h-11"
                        placeholder="ejemplo@proveedor.com"></asp:TextBox>
                </label>

                <label class="flex flex-col flex-1">
                    <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Dirección</p>
                    <asp:TextBox ID="txtDireccion" runat="server"
                        CssClass="form-input flex w-full ... h-11"
                        placeholder="Ej: Av. Siempre Viva 123"></asp:TextBox>
                </label>

                <div class="flex items-center justify-end gap-3 mt-4">
                    <asp:HyperLink ID="btnCancelar" runat="server" NavigateUrl="~/ProveedoresListado.aspx"
                        CssClass="flex min-w-[84px] ... bg-slate-200 ...">
                        <span class="truncate">Cancelar</span>
                    </asp:HyperLink>
                    
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar"
                        CssClass="flex min-w-[84px] ... bg-primary text-white ..."
                        CausesValidation="false" 
                        OnClick="btnGuardar_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>