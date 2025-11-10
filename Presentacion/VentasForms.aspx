<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VentasForms.aspx.cs" Inherits="Presentacion.VentasForms" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    
    <script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function () {
        var txt = document.getElementById("<%= txtBuscarCliente.ClientID %>");
        if (txt) {
            txt.addEventListener("keydown", function (e) {
                if (e.key === "Enter") {
                    e.preventDefault(); // Evita comportamiento por defecto
                    __doPostBack('<%= txtBuscarCliente.UniqueID %>', '');
                }
            });
        }
    });
    </script>
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   
    <body class="bg-background-light dark:bg-background-dark font-display text-text-light dark:text-text-dark">
    
      <div class="relative flex h-auto min-h-screen w-full flex-col overflow-x-hidden">

        <div class="layout-container flex h-full grow flex-col">
            <div class="flex flex-1 justify-center py-5">
                <div class="layout-content-container flex flex-col w-full max-w-7xl px-4 md:px-8">

                    <!-- Título -->
                    <div class="flex flex-wrap justify-between gap-3 p-4">
                        <p class="text-text-light dark:text-text-dark text-4xl font-black leading-tight tracking-[-0.033em]">
                            Registrar Nueva Venta
                        </p>
                    </div>

                    <div class="flex flex-col lg:flex-row gap-8 p-4">

                        <!-- PANEL IZQUIERDO -->
                        <div class="flex-grow">

                            <!-- Cliente -->
                            <div class="relative px-4 py-3">
                                <div class="flex w-full flex-1 items-stretch rounded-lg">
                                    <asp:TextBox ID="txtBuscarCliente" runat="server"
                                        CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-text-light dark:text-text-dark focus:outline-0 focus:ring-0 border border-border-light dark:border-border-dark bg-white dark:bg-background-dark focus:border-primary h-14 placeholder:text-gray-400 p-[15px] rounded-r-none border-r-0 pr-2 text-base font-normal leading-normal"
                                        placeholder="Buscar por nombre, CUIT o ID de cliente..."
                                        OnTextChanged="txtBuscarCliente_TextChanged"
                                        AutoPostBack="true">
                                    </asp:TextBox>

                                </div>

                                <!-- GRID flotante -->
                                <div class="absolute top-[70px] left-0 right-0 z-50 bg-white dark:bg-background-dark rounded-lg shadow-lg border border-border-light dark:border-border-dark max-h-64 overflow-y-auto">
                                    <asp:GridView ID="gvClientes" runat="server" AutoGenerateColumns="false"
                                        CssClass="w-full text-sm text-gray-700 dark:text-gray-100"
                                        GridLines="None" OnSelectedIndexChanged="gvClientes_SelectedIndexChanged">
                                        <Columns>
                                            <asp:BoundField DataField="IdCliente" HeaderText="ID" />
                                            <asp:BoundField DataField="NombreCompleto" HeaderText="Cliente" />
                                            <asp:BoundField DataField="CUIT" HeaderText="CUIT" />
                                            <asp:CommandField ShowSelectButton="true" SelectText="Seleccionar" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>

                            <!-- Producto -->
                            <div class="flex max-w-[480px] flex-wrap items-end gap-4 px-4 py-3">
                                <label class="flex flex-col min-w-40 flex-1">
                                    <p class="text-base font-medium pb-2">Añadir Productos a la Venta</p>
                                    <asp:TextBox ID="txtBuscarProducto" runat="server"
                                        CssClass="form-input flex w-full flex-1 rounded-lg text-text-light dark:text-text-dark 
                                        border border-border-light dark:border-border-dark bg-white dark:bg-background-dark 
                                        focus:border-primary h-14 placeholder:text-gray-400 p-[15px] text-base"
                                        placeholder="Buscar producto por nombre o código..."></asp:TextBox>
                                </label>
                            </div>

                            <!-- Tabla de Productos -->
                            <div class="px-4 py-3">
                                <div class="flex overflow-hidden rounded-lg border border-border-light dark:border-border-dark 
                                    bg-white dark:bg-background-dark">
                                    <asp:GridView ID="gvProductos" runat="server"
                                        AutoGenerateColumns="False"
                                        CssClass="w-full text-sm text-left text-text-light dark:text-text-dark"
                                        GridLines="None">
                                        <Columns>
                                            <asp:BoundField HeaderText="Producto" DataField="Nombre" />
                                            <asp:BoundField HeaderText="Cantidad" DataField="Cantidad" />
                                            <asp:BoundField HeaderText="Precio Unitario" DataField="PrecioUnitario" />
                                            <asp:BoundField HeaderText="Subtotal" DataField="Subtotal" />
                                            <asp:TemplateField HeaderText="Acción">
                                                <ItemTemplate>
                                                    <asp:Button ID="btnEliminar" runat="server" Text="✖"
                                                        CssClass="text-error hover:text-error/80" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>

                            <!-- Si no hay productos -->
                            <div class="flex flex-col p-4">
                                <div class="flex flex-col items-center gap-6 rounded-lg border-2 border-dashed 
                                    border-border-light dark:border-border-dark px-6 py-14">
                                    <div class="flex flex-col items-center gap-2">
                                        <p class="text-lg font-bold text-center">Aún no se han añadido productos</p>
                                        <p class="text-sm text-center">Añade productos para empezar a registrar la venta.</p>
                                    </div>
                                    <asp:Button ID="btnAgregarProducto" runat="server" Text="Añadir Producto"
                                        CssClass="flex items-center justify-center rounded-lg h-10 px-4 
                                        bg-primary/20 text-primary dark:text-white dark:bg-primary/50 text-sm font-bold 
                                        hover:bg-primary/30 dark:hover:bg-primary/60 transition-colors" />
                                </div>
                            </div>

                        </div>

                        <!-- PANEL DERECHO -->
                        <div class="w-full lg:w-96 flex-shrink-0">
                            <div class="bg-white dark:bg-background-dark/50 rounded-lg shadow p-6 sticky top-5">
                                <h3 class="text-xl font-bold mb-4">Resumen de la Venta</h3>

                                <div class="space-y-4">
                                    <div class="flex items-center justify-between">
                                        <label class="text-sm font-medium">Porcentaje de Ganancia (%):</label>
                                        <asp:TextBox ID="txtGanancia" runat="server" Text="25"
                                            CssClass="w-24 form-input rounded-lg border-border-light dark:border-border-dark 
                                            bg-white dark:bg-background-dark focus:ring-primary focus:border-primary text-right" />
                                    </div>

                                    <div class="border-t border-border-light dark:border-border-dark my-4"></div>

                                    <div class="flex justify-between"><span>Subtotal</span>
                                        <asp:Label ID="lblSubtotal" runat="server" Text="$0.00"></asp:Label>
                                    </div>

                                    <div class="flex justify-between items-center">
                                        <span>Impuestos (%)</span>
                                        <asp:TextBox ID="txtImpuestos" runat="server" Text="21"
                                            CssClass="w-24 form-input rounded-lg border-border-light dark:border-border-dark 
                                            bg-white dark:bg-background-dark focus:ring-primary focus:border-primary text-right" />
                                    </div>

                                    <div class="flex justify-between items-center">
                                        <span>Descuento ($)</span>
                                        <asp:TextBox ID="txtDescuento" runat="server"
                                            CssClass="w-24 form-input rounded-lg border-border-light dark:border-border-dark 
                                            bg-white dark:bg-background-dark focus:ring-primary focus:border-primary text-right"
                                            placeholder="0.00" />
                                    </div>

                                    <div class="border-t border-border-light dark:border-border-dark my-4"></div>

                                    <div class="flex justify-between text-lg font-bold">
                                        <span>Total a Pagar</span>
                                        <asp:Label ID="lblTotal" runat="server" Text="$0.00"></asp:Label>
                                    </div>

                                    <div class="pt-4 text-sm">
                                        <span>Nro. de Factura:</span>
                                        <span class="font-mono bg-gray-200 dark:bg-gray-700 py-1 px-2 rounded">
                                            FAC-2024-00123
                                        </span>
                                    </div>
                                </div>

                                <!-- Botones -->
                                <div class="mt-6 space-y-3">
                                    <asp:Button ID="btnConfirmar" runat="server" Text="Confirmar y Generar Factura"
                                        CssClass="w-full flex items-center justify-center rounded-lg h-12 px-6 
                                        bg-primary text-white text-base font-bold hover:bg-primary/90 transition-colors" />

                                    <asp:Button ID="btnBorrador" runat="server" Text="Guardar Borrador"
                                        CssClass="w-full flex items-center justify-center rounded-lg h-12 px-6 
                                        bg-gray-200 dark:bg-gray-700 text-text-light dark:text-text-dark text-base font-bold 
                                        hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors" />

                                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar"
                                        CssClass="w-full text-center text-primary dark:text-info hover:underline" />
                                </div>
                            </div>
                        </div>
                    </div> <!-- cierre flex-row -->
                </div>
            </div>
        </div>
    </div>
</body>

    <script type="text/javascript">
        function clickEnter(e) {
            if (e.key === "Enter") {
                e.preventDefault(); // evita que se envíe el form completo
                __doPostBack('<%= txtBuscarCliente.UniqueID %>', '');
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
