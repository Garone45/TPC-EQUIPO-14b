<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Presentacion._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <%-- Mensaje de error --%>
  <div class="w-full">
        <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="bg-red-50 border-l-4 border-red-500 text-red-700 p-4 mb-8 shadow-sm rounded-r flex items-start gap-3" role="alert">
            <span class="material-symbols-outlined text-red-500 text-xl mt-0.5">error</span>
            <div>
                <p class="font-bold text-sm">Atención</p>
                <asp:Label ID="lblError" runat="server" Text="" CssClass="text-sm"></asp:Label>
            </div>
        </asp:Panel>
    </div>
    <%-- TITULOS --%>
    <div class="mb-8 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
            <h1 class="text-3xl font-black text-slate-900 dark:text-white tracking-tight">
                Hola, <asp:Label ID="lblNombreUsuario" runat="server" Text="Usuario" CssClass="text-primary"></asp:Label>
            </h1>
            <p class="mt-2 text-slate-500 dark:text-slate-400 font-medium">
                Aquí tienes un resumen de lo que pasa en tu negocio hoy.
            </p>
        </div>
        <div class="shrink-0">
            <span class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white border border-slate-200 shadow-sm dark:bg-slate-800 dark:border-slate-700 text-slate-600 dark:text-slate-300 text-sm font-semibold">
                <span class="material-symbols-outlined text-[18px] text-primary">calendar_today</span>
                <%= DateTime.Now.ToString("dd 'de' MMMM, yyyy") %>
            </span>
        </div>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
        
        <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 hover:shadow-md transition-all group">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-slate-500 dark:text-slate-400 text-sm font-bold uppercase tracking-wider">Ventas Hoy</h3>
                <div class="p-2 bg-green-50 text-green-600 rounded-lg group-hover:bg-green-600 group-hover:text-white transition-colors">
                    <span class="material-symbols-outlined">payments</span>
                </div>
            </div>
            <p class="text-3xl font-black text-slate-900 dark:text-white mb-1">
                <asp:Label ID="lblVentasHoy" runat="server" Text="$ 0.00"></asp:Label>
            </p>
            <p class="text-xs font-medium text-green-600 flex items-center gap-1 bg-green-50 w-fit px-2 py-1 rounded-md">
                <span class="material-symbols-outlined text-[14px]">trending_up</span> 
                <asp:Label ID="lblPorcentaje" runat="server" Text="+0%"></asp:Label> vs ayer
            </p>
        </div>

        <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 hover:shadow-md transition-all group">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-slate-500 dark:text-slate-400 text-sm font-bold uppercase tracking-wider">Pendientes</h3>
                <div class="p-2 bg-orange-50 text-orange-600 rounded-lg group-hover:bg-orange-500 group-hover:text-white transition-colors">
                    <span class="material-symbols-outlined">pending_actions</span>
                </div>
            </div>
            <p class="text-3xl font-black text-slate-900 dark:text-white mb-1">
                <asp:Label ID="lblPedidosPendientes" runat="server" Text="0"></asp:Label>
            </p>
            <p class="text-xs font-medium text-orange-600 bg-orange-50 w-fit px-2 py-1 rounded-md">Requieren atención</p>
        </div>

        <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 hover:shadow-md transition-all group relative">
            
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-slate-500 dark:text-slate-400 text-sm font-bold uppercase tracking-wider">Stock Bajo</h3>
                <div class="p-2 bg-red-50 text-red-600 rounded-lg group-hover:bg-red-500 group-hover:text-white transition-colors">
                    <span class="material-symbols-outlined">inventory_2</span>
                </div>
            </div>

            <p class="text-3xl font-black text-slate-900 dark:text-white mb-2">
                <asp:Label ID="lblAlertasStock" runat="server" Text="0"></asp:Label>
            </p>

            <div class="flex items-center justify-between">
                
                <p class="text-xs font-medium text-red-600 bg-red-50 px-2 py-1 rounded-md">
                    Reponer urgente
                </p>

                <asp:HyperLink ID="btnVerBajoStock" runat="server" 
                    NavigateUrl="~/ProductosListados.aspx?filtro=stockbajo" 
                    CssClass="text-xs font-bold text-red-400 hover:text-red-600 flex items-center gap-1 transition-colors cursor-pointer group/btn">
                    Ver lista 
                    <span class="material-symbols-outlined text-[16px] group-hover/btn:translate-x-1 transition-transform">arrow_forward</span>
                </asp:HyperLink>

            </div>
        </div>

        <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 hover:shadow-md transition-all group">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-slate-500 dark:text-slate-400 text-sm font-bold uppercase tracking-wider">Clientes</h3>
                <div class="p-2 bg-blue-50 text-blue-600 rounded-lg group-hover:bg-blue-600 group-hover:text-white transition-colors">
                    <span class="material-symbols-outlined">group</span>
                </div>
            </div>
            <p class="text-3xl font-black text-slate-900 dark:text-white mb-1">
                <asp:Label ID="lblClientesActivos" runat="server" Text="0"></asp:Label>
            </p>
            <p class="text-xs font-medium text-blue-600 bg-blue-50 w-fit px-2 py-1 rounded-md">Total activos</p>
        </div>
    </div>

    <div class="flex items-center gap-2 mb-6">
        <div class="p-1.5 bg-primary/10 rounded-lg text-primary">
            <span class="material-symbols-outlined">analytics</span> 
        </div>
        <h2 class="text-xl font-bold text-slate-900 dark:text-white">Centro de Reportes</h2>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        
        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 overflow-hidden hover:border-primary/50 transition-colors group cursor-pointer" onclick="document.getElementById('<%= btnDescargarVentas.ClientID %>').click();">
            <div class="p-6">
                <div class="flex justify-between items-start mb-4">
                    <div class="p-3 bg-green-100 text-green-700 rounded-xl group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-3xl">table_view</span> 
                    </div>
                    <span class="material-symbols-outlined text-slate-300 group-hover:text-primary transition-colors">download</span>
                </div>
                <h3 class="text-lg font-bold text-slate-900 dark:text-white mb-2">Reporte General de Ventas</h3>
                <p class="text-slate-500 dark:text-slate-400 text-sm mb-6">Exporta el historial completo de facturación detallado por fecha, cliente y vendedor.</p>
                
                <asp:Button ID="btnDescargarVentas" runat="server" OnClick="btnDescargarVentas_Click" 
                    CssClass="w-full inline-flex justify-center items-center gap-2 px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-slate-700 font-bold hover:bg-green-600 hover:text-white hover:border-green-600 transition-all cursor-pointer" 
                    Text="Descargar Excel" />
            </div>
        </div>

        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 overflow-hidden hover:border-primary/50 transition-colors group cursor-pointer" onclick="document.getElementById('<%= btnDescargarCompras.ClientID %>').click();">
            <div class="p-6">
                <div class="flex justify-between items-start mb-4">
                    <div class="p-3 bg-blue-100 text-blue-700 rounded-xl group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-3xl">inventory</span>
                    </div>
                    <span class="material-symbols-outlined text-slate-300 group-hover:text-primary transition-colors">download</span>
                </div>
                <h3 class="text-lg font-bold text-slate-900 dark:text-white mb-2">Compras & Proveedores</h3>
                <p class="text-slate-500 dark:text-slate-400 text-sm mb-6">Analiza las adquisiciones de stock, gastos por proveedor y evolución de costos.</p>
                
                <asp:Button ID="btnDescargarCompras" runat="server" OnClick="btnDescargarCompras_Click" 
                    CssClass="w-full inline-flex justify-center items-center gap-2 px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-slate-700 font-bold hover:bg-blue-600 hover:text-white hover:border-blue-600 transition-all cursor-pointer" 
                    Text="Descargar Excel" />
            </div>
        </div>

    </div>
</asp:Content>