<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MarcasForm.aspx.cs" Inherits="Presentacion.MarcasForm" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <!-- Este contenedor centra el formulario y le da un ancho máximo -->
    <div class="max-w-2xl mx-auto">
        
        <!-- 1. Título de la Página -->
        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Detalle de Marca</h1>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Complete los datos de la marca.</p>
            </div>
        </div>

        <!-- 2. Formulario de Marca -->
        <div class="bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60">
            <div class="flex flex-col gap-5">
                
                <label class="flex flex-col flex-1">
                    <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Descripción</p>
                    <asp:TextBox ID="txtDescripcion" runat="server" 
                        CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-slate-700/50 h-11 placeholder:text-slate-400 dark:placeholder:text-slate-500 px-3 text-sm font-normal leading-normal" 
                        placeholder="Ej: Samsung, Apple, Arcor"></asp:TextBox>
                </label>
                
                <div class="flex items-center justify-end gap-3 mt-4">
                    
                    <asp:HyperLink ID="btnCancelar" runat="server" NavigateUrl="~/MarcasListado.aspx"
                        CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-slate-200 dark:bg-slate-700 text-slate-700 dark:text-slate-200 text-sm font-bold leading-normal tracking-[0.015em] hover:bg-slate-300 dark:hover:bg-slate-600">
                        <span class="truncate">Cancelar</span>
                    </asp:HyperLink>
                    
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" 
                        CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90" 
                         />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
