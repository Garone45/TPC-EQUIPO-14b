<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Presentacion._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-12">
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 shadow-sm rounded-r" role="alert">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined">error</span>
                    <div>
                        <p class="font-bold">Atención</p>
                        <asp:Label ID="lblError" runat="server" Text=""></asp:Label>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>

    <div class="mb-8 flex flex-col sm:flex-row sm:items-center sm:justify-between">
        <div>
            <h1 class="text-3xl font-extrabold text-slate-900 dark:text-white tracking-tight">
                Hola, <asp:Label ID="lblNombreUsuario" runat="server" Text="Usuario" CssClass="text-primary"></asp:Label>
            </h1>
            <p class="mt-2 text-slate-500 dark:text-slate-400">
                Aquí tienes un resumen de lo que pasa en tu negocio hoy.
            </p>
        </div>
        <div class="mt-4 sm:mt-0">
            <span class="inline-flex items-center gap-1 px-3 py-1 rounded-full bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-300 text-sm font-medium">
                <span class="material-symbols-outlined text-[18px]">calendar_today</span>
                <%= DateTime.Now.ToString("dd 'de' MMMM, yyyy") %>
            </span>
        </div>
    </div>


    <!-- Dashboard estadisticas -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        
        <div class="bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700 hover:shadow-md transition-shadow">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-slate-500 dark:text-slate-400 text-sm font-medium">Ventas de Hoy</h3>
                <div class="p-2 bg-green-100 dark:bg-green-900/30 rounded-lg text-green-600">
                    <span class="material-symbols-outlined">payments</span>
                </div>
            </div>
            <p class="text-2xl font-bold text-slate-900 dark:text-white">
                <asp:Label ID="lblVentasHoy" runat="server" Text="$ 0.00"></asp:Label>
            </p>
            <p class="text-xs text-green-500 mt-1 flex items-center gap-1">
                <span class="material-symbols-outlined text-[14px]">trending_up</span> 
                <asp:Label ID="lblPorcentaje" runat="server" Text="+0%"></asp:Label> desde ayer
            </p>
        </div>

        <div class="bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700 hover:shadow-md transition-shadow">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-slate-500 dark:text-slate-400 text-sm font-medium">Pedidos Pendientes</h3>
                <div class="p-2 bg-orange-100 dark:bg-orange-900/30 rounded-lg text-orange-600">
                    <span class="material-symbols-outlined">pending_actions</span>
                </div>
            </div>
            <p class="text-2xl font-bold text-slate-900 dark:text-white">
                <asp:Label ID="lblPedidosPendientes" runat="server" Text="0"></asp:Label>
            </p>
            <p class="text-xs text-slate-500 mt-1">Requieren atención</p>
        </div>

        <div class="bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700 hover:shadow-md transition-shadow">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-slate-500 dark:text-slate-400 text-sm font-medium">Alertas de Stock</h3>
                <div class="p-2 bg-red-100 dark:bg-red-900/30 rounded-lg text-red-600">
                    <span class="material-symbols-outlined">inventory_2</span>
                </div>
            </div>
            <p class="text-2xl font-bold text-slate-900 dark:text-white">
                <asp:Label ID="lblAlertasStock" runat="server" Text="0"></asp:Label>
            </p>
            <p class="text-xs text-red-500 mt-1">Productos bajo el mínimo</p>
        </div>

        <div class="bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700 hover:shadow-md transition-shadow">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-slate-500 dark:text-slate-400 text-sm font-medium">Clientes Activos</h3>
                <div class="p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg text-primary">
                    <span class="material-symbols-outlined">group</span>
                </div>
            </div>
            <p class="text-2xl font-bold text-slate-900 dark:text-white">
                <asp:Label ID="lblClientesActivos" runat="server" Text="0"></asp:Label>
            </p>
            <p class="text-xs text-slate-500 mt-1">Total registrados</p>
        </div>
    </div>

    <h2 class="text-xl font-bold text-slate-900 dark:text-white mb-4 flex items-center gap-2">
        <span class="material-symbols-outlined text-slate-400">analytics</span> Centro de Reportes
    </h2>

    <!-- Dashboard reportesss -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!--  Reporte de ventas  -->
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700 overflow-hidden group">
            <div class="p-6">
                <div class="flex items-start justify-between">
                    <div>
                        <h3 class="text-lg font-bold text-slate-900 dark:text-white">Reporte General de Ventas</h3>
                        <p class="text-slate-500 dark:text-slate-400 text-sm mt-1">Exporta el historial completo de facturación, detalle por cliente y vendedor.</p>
                    </div>
                    <div class="w-12 h-12 bg-green-50 dark:bg-green-900/20 rounded-lg flex items-center justify-center text-green-600">
                        <span class="material-symbols-outlined text-3xl">table_view</span> 
                    </div>
                </div>
                <div class="mt-6">
                    <asp:Button ID="btnDescargarVentas" runat="server" OnClick="btnDescargarVentas_Click" 
                    CssClass="w-full inline-flex justify-center items-center gap-2 px-4 py-3 bg-white border border-slate-300 dark:border-slate-600 rounded-lg text-slate-700 dark:text-slate-200 font-medium hover:bg-slate-50 dark:hover:bg-slate-700 hover:text-green-700 transition-all group-hover:border-green-500 group-hover:text-green-600 cursor-pointer" 
                    Text="⬇ Descargar Excel de Ventas" />
                </div>
            </div>
            <div class="bg-slate-50 dark:bg-slate-700/50 px-6 py-3 border-t border-slate-100 dark:border-slate-700">
                <p class="text-xs text-slate-400 flex items-center gap-1">
                    <span class="material-symbols-outlined text-[14px]">info</span> Incluye filtros por fecha y estado.
                </p>
            </div>
        </div>
        <!-- Compras stock -->
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700 overflow-hidden group">
            <div class="p-6">
                <div class="flex items-start justify-between">
                    <div>
                        <h3 class="text-lg font-bold text-slate-900 dark:text-white">Reporte de Compras & Proveedores</h3>
                        <p class="text-slate-500 dark:text-slate-400 text-sm mt-1">Detalle de adquisiciones, gastos por proveedor y evolución de costos.</p>
                    </div>
                    <div class="w-12 h-12 bg-green-50 dark:bg-green-900/20 rounded-lg flex items-center justify-center text-green-600">
                        <span class="material-symbols-outlined text-3xl">receipt_long</span>
                    </div>
                </div>
                <div class="mt-6">
                    <asp:Button ID="btnDescargarCompras" runat="server" OnClick="btnDescargarCompras_Click" 
                    CssClass="w-full inline-flex justify-center items-center gap-2 px-4 py-3 bg-white border border-slate-300 dark:border-slate-600 rounded-lg text-slate-700 dark:text-slate-200 font-medium hover:bg-slate-50 dark:hover:bg-slate-700 hover:text-green-700 transition-all group-hover:border-green-500 group-hover:text-green-600 cursor-pointer" 
                    Text="⬇ Descargar Reporte Stock/Prov" />
                </div>
            </div>
            <div class="bg-slate-50 dark:bg-slate-700/50 px-6 py-3 border-t border-slate-100 dark:border-slate-700">
                <p class="text-xs text-slate-400 flex items-center gap-1">
                    <span class="material-symbols-outlined text-[14px]">info</span> Datos actualizados al momento.
                </p>
            </div>
        </div>

    </div>

</asp:Content>