<%@ Page Title="Gestión de Categoría" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CategoriasForm.aspx.cs" Inherits="Presentacion.CategoriasForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-2xl mx-auto">
        
        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <asp:Label ID="lblTitulo" runat="server" Text="Agregar Nueva Categoría"
                    CssClass="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]"></asp:Label>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Complete los datos de la categoría.</p>
            </div>
        </div>

        <div class="bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60">
            <div class="flex flex-col gap-5">
                
                <label class="flex flex-col flex-1">
                    <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Descripción</p>
                    <asp:TextBox ID="txtDescripcion" runat="server" 
                        CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-slate-700/50 h-11 placeholder:text-slate-400 dark:placeholder:text-slate-500 px-3 text-sm font-normal leading-normal" 
                        placeholder="Ej: Electrónica, Limpieza..."></asp:TextBox>
                    
                    <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" 
                        ControlToValidate="txtDescripcion"
                        ErrorMessage="La descripción es requerida."
                        CssClass="text-red-500 text-xs mt-1"
                        Display="Dynamic" />
                </label>
                
                <div class="flex items-center justify-end gap-3 mt-4">
                    
                    <asp:HyperLink ID="btnCancelar" runat="server" NavigateUrl="~/CategoriaListado"
                        CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-slate-200 dark:bg-slate-700 text-slate-700 dark:text-slate-200 text-sm font-bold leading-normal tracking-[0.015em] hover:bg-slate-300 dark:hover:bg-slate-600">
                        <span class="truncate">Cancelar</span>
                    </asp:HyperLink>
                    
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" 
                        CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90" 
                        CausesValidation="false" 
                        OnClick="btnGuardar_Click" /> 
                </div>
            </div>
        </div>
    </div>
</asp:Content>