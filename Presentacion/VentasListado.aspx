<%@ Page Title="Gestión de Ventas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VentasListado.aspx.cs" Inherits="Presentacion.VentasListado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com" rel="preconnect" />
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect" />
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#137fec",
                        "background-light": "#f6f7f8",
                        "background-dark": "#101922",
                        "success": "#2ECC71",
                        "warning": "#F1C40F",
                        "danger": "#E74C3C"
                    },
                    fontFamily: {
                        "display": ["Manrope", "sans-serif"]
                    },
                    borderRadius: { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
                },
            },
        }
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="font-display bg-background-light dark:bg-background-dark text-[#2C3E50] dark:text-gray-200">


        <main class="flex-grow p-4 md:p-8">
            <div class="mx-auto max-w-7xl">
                <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
                    <div class="flex flex-col gap-1">
                        <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Listado de Ventas</h1>
                        <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Administra, filtra y busca todas las ventas de tu negocio.</p>
                    </div>
                    <asp:HyperLink ID="lnkNuevaVenta" runat="server" NavigateUrl="~/VentaForm.aspx" CssClass="flex items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold gap-2">
                        <span class="material-symbols-outlined">add_circle</span>
                        <span class="truncate">Nueva Venta</span>
                    </asp:HyperLink>
                </div>

                <div class="mb-4 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 p-4">
                    <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
                        <div class="lg:col-span-2">
                            <label class="sr-only" for="txtBuscar">Buscar</label>
                            <div class="relative">
                                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                    <span class="material-symbols-outlined text-gray-400">search</span>
                                </div>
                                <asp:TextBox ID="txtBuscar" runat="server"
                                    CssClass="block w-full rounded-lg border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 pl-10 h-11 focus:border-primary focus:ring-primary dark:placeholder-gray-400"
                                    placeholder="Buscar por Nº de factura o cliente..."
                                    AutoPostBack="false" /> </div>
                        </div>
                        <div>
                            <label class="sr-only" for="btnRangoFechas">Rango de Fechas</label>
                            <asp:LinkButton ID="btnRangoFechas" runat="server"
                                CssClass="flex h-11 w-full items-center justify-between rounded-lg border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 px-3 text-left">
                                <div class="flex items-center gap-2 text-gray-500 dark:text-gray-400">
                                    <span class="material-symbols-outlined">calendar_month</span>
                                    <span>Rango de Fechas</span>
                                </div>
                                <span class="material-symbols-outlined text-gray-400">expand_more</span>
                            </asp:LinkButton>
                        </div>
                        <div>
                            <label class="sr-only" for="btnCliente">Cliente</label>
                            <asp:LinkButton ID="btnCliente" runat="server"
                                CssClass="flex h-11 w-full items-center justify-between rounded-lg border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 px-3 text-left">
                                <div class="flex items-center gap-2 text-gray-500 dark:text-gray-400">
                                    <span class="material-symbols-outlined">group</span>
                                    <span>Todos los clientes</span>
                                </div>
                                <span class="material-symbols-outlined text-gray-400">expand_more</span>
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>

                <asp:Panel ID="pnlTablaVentas" runat="server" class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-700">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700 bg-white dark:bg-gray-800">
                            <thead class="bg-gray-50 dark:bg-gray-700/50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500 dark:text-gray-300" scope="col">Nº Pedido</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500 dark:text-gray-300" scope="col">Cliente</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500 dark:text-gray-300" scope="col">Fecha</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500 dark:text-gray-300" scope="col">Estado</th>
                                    <th class="px-6 py-3 text-right text-xs font-medium uppercase tracking-wider text-gray-500 dark:text-gray-300" scope="col">Total</th>
                                    <th class="px-6 py-3 text-center text-xs font-medium uppercase tracking-wider text-gray-500 dark:text-gray-300" scope="col">Acciones</th>
                                </tr>
                            </thead>
                            
                            <asp:Repeater ID="rptVentas" runat="server">
                                <HeaderTemplate>
                                    <tbody class="divide-y divide-gray-200 dark:divide-gray-700">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr class="hover:bg-gray-50 dark:hover:bg-gray-700/50 transition duration-150">
                                        <td class="whitespace-nowrap px-6 py-4 text-sm font-medium"><%# Eval("IDPedido") %></td>
                                        <td class="whitespace-nowrap px-6 py-4 text-sm"><%# Eval("NombreCliente") %></td>
                                        <td class="whitespace-nowrap px-6 py-4 text-sm text-gray-500 dark:text-gray-400"><%# Eval("FechaCreacion", "{0:dd/MM/yyyy}") %></td>
                                        <td class="whitespace-nowrap px-6 py-4 text-sm">
                                            <span class='inline-flex items-center rounded-full <%# GetEstadoClass(Eval("Estado").ToString()) %> px-2.5 py-0.5 text-xs font-semibold'>
                                                <%# Eval("Estado") %>
                                            </span>
                                        </td>
                                        <td class="whitespace-nowrap px-6 py-4 text-right text-sm font-medium"><%# Eval("Total", "{0:C}") %></td>
                                        <td class="whitespace-nowrap px-6 py-4 text-center text-sm">
                                            <a href='<%# Eval("IDPedido", "~/VentaDetalle.aspx?id={0}") %>' aria-label="Ver Detalle" class="p-2 text-gray-500 hover:text-primary dark:text-gray-400 dark:hover:text-primary">
                                                <span class="material-symbols-outlined">visibility</span>
                                            </a>
                                            <a href='<%# Eval("IDPedido", "~/ImprimirFactura.aspx?id={0}") %>' aria-label="Imprimir Factura" class="p-2 text-gray-500 hover:text-primary dark:text-gray-400 dark:hover:text-primary">
                                                <span class="material-symbols-outlined">print</span>
                                            </a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </tbody>
                                </FooterTemplate>
                            </asp:Repeater>

                        </table>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlVacio" runat="server" Visible="false" CssClass="py-16">
                    <div class="flex flex-col items-center gap-4 text-center">
                        <span class="material-symbols-outlined text-6xl text-gray-300 dark:text-gray-600">receipt_long</span>
                        <h3 class="text-lg font-semibold text-slate-900 dark:text-white">No se encontraron ventas</h3>
                        <p class="text-gray-500 dark:text-gray-400">Intenta ajustar los filtros o crea una nueva venta.</p>
                        <asp:HyperLink ID="lnkNuevaVentaVacio" runat="server"
                            NavigateUrl="~/VentaForm.aspx"
                            CssClass="mt-2 flex items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold gap-2">
                            <span class="material-symbols-outlined">add_circle</span>
                            <span class="truncate">Crear una nueva venta</span>
                        </asp:HyperLink>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlPaginacion" runat="server" class="flex items-center justify-between border-t border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 px-4 py-3 sm:px-6 rounded-b-xl">
                    </asp:Panel>
            </div>
        </main>
    </div>
</asp:Content>              
       