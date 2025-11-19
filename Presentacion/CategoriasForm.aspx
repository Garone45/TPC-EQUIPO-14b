<%@ Page Title="Gestión de Categorías" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CategoriasForm.aspx.cs" Inherits="Presentacion.CategoriasForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="max-w-2xl mx-auto">
        
        <div class="mb-8 flex flex-col gap-1">
            <h1 class="text-3xl font-black text-slate-900 dark:text-white">Gestión de Categorías</h1>
             <p class="text-slate-500 dark:text-slate-400 text-base">Crea o edita las categorías de tus productos.</p>
        </div>

        <asp:UpdatePanel ID="UpdatePanelMensajes" runat="server">
            <ContentTemplate>
                 <div class="mb-4">
                    <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" class="p-4 rounded-lg block"></asp:Label>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div class="bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700">
            
            <div class="mb-4" id="divId" runat="server" visible="false">
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">ID</label>
                <asp:TextBox ID="txtId" runat="server" ReadOnly="true" CssClass="w-full bg-slate-100 border border-slate-300 rounded-lg px-3 py-2 text-slate-500"></asp:TextBox>
            </div>

            <div class="mb-6">
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">Nombre de la Categoría *</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-input w-full border border-slate-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500" placeholder="Ej: Bebidas"></asp:TextBox>
                
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDescripcion"
                    ErrorMessage="El nombre es obligatorio."
                    CssClass="text-red-500 text-xs font-bold mt-1 block" Display="Dynamic" />
            </div>

            <div class="flex justify-end gap-3 mt-6">
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" PostBackUrl="~/CategoriaListado.aspx" CausesValidation="false"
                    CssClass="px-4 py-2 bg-slate-200 text-slate-700 rounded-lg font-bold hover:bg-slate-300 cursor-pointer" />
                
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" OnClick="btnGuardar_Click"
                    CssClass="px-4 py-2 bg-blue-600 text-white rounded-lg font-bold hover:bg-blue-700 cursor-pointer" />
            </div>

        </div>
    </div>

</asp:Content>