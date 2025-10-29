﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MarcasListado.aspx.cs" Inherits="Presentacion.MarcasListado" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="max-w-7xl mx-auto">
        
        <!-- 1. Título y Botón "Nuevo" (Estilo "Clientes") -->
        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Gestión de Marcas</h1>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Busca y administra las marcas de tu negocio.</p>
            </div>
            <div class="flex items-center gap-4">
                <asp:HyperLink ID="btnNuevaMarca" runat="server" NavigateUrl="~/MarcasForm.aspx"
                    CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90 gap-2">
                    <span class="material-symbols-outlined text-base">add</span>
                    <span class="truncate">Nueva Marca</span>
                </asp:HyperLink>
            </div>
        </div>

        <!-- 2. Barra de Búsqueda (Estilo "Clientes") -->
        <div class="flex justify-between items-center gap-4 mb-4">
            <div class="relative w-full sm:max-w-xs">
                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                    <span class="material-symbols-outlined text-slate-400">search</span>
                </div>
                <asp:TextBox ID="txtBuscar" runat="server"
                    CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-10 placeholder:text-slate-400 dark:placeholder:text-slate-500 pl-10 pr-4 text-sm font-normal leading-normal" 
                    placeholder="Buscar marca..."></asp:TextBox>
            </div>
        </div>
        
        <!-- 3. Grilla de Marcas (Estilo "Clientes") -->
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60 overflow-hidden">
            <div class="overflow-x-auto">
                
                <asp:GridView ID="gvMarcas" runat="server" 
                    AutoGenerateColumns="False" 
                    DataKeyNames="IdMarca"
                    CssClass="w-full text-sm text-left text-slate-500 dark:text-slate-400"
                    GridLines="None" 
                    AllowPaging="True" PageSize="10" 
                    >
                    
                    <HeaderStyle CssClass="text-xs text-slate-700 dark:text-slate-300 uppercase bg-slate-50 dark:bg-slate-700/50" />
                    <RowStyle CssClass="bg-white dark:bg-slate-800 border-b dark:border-slate-700/60 hover:bg-slate-50 dark:hover:bg-slate-700/40" />
                    <PagerStyle CssClass="flex items-center justify-between p-4" />

                    <Columns>
                        <asp:BoundField DataField="Descripcion" HeaderText="Descripción" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" />
                        
                        <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center">
                            <ItemTemplate>
                                <div class="flex justify-center gap-2">
                                    
                                    <asp:HyperLink ID="btnEditar" runat="server" 
                                        NavigateUrl='<%# Eval("IdMarca", "MarcasForm.aspx?id={0}") %>'
                                        CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-primary/10 hover:text-primary dark:hover:bg-primary/20">
                                        <span class="material-symbols-outlined text-lg">edit</span>
                                    </asp:HyperLink>
                                    
                                    <asp:LinkButton ID="btnEliminar" runat="server" 
                                        CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-red-500/10 hover:text-red-500 dark:hover:bg-red-500/20"
                                        OnClientClick="return confirm('¿Está seguro de que desea eliminar esta marca?');">
                                        <span class="material-symbols-outlined text-lg">delete</span>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                
            </div>
        </div>
    </div>
</asp:Content>
