<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductosForms.aspx.cs" Inherits="Presentacion.ProductosForms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var costoID = '#<%= txtPrecioCostoActual.ClientID %>';
            var gananciaID = '#<%= txtPorcentajeGanancia.ClientID %>';
            var ventaID = '#<%= txtPrecioVenta.ClientID %>';

            function calcularPrecioVenta() {
                var costo = parseFloat($(costoID).val().replace(',', '.'));
                var ganancia = parseFloat($(gananciaID).val().replace(',', '.'));

                if (isNaN(costo) || isNaN(ganancia) || costo < 0 || ganancia < 0) {
                    $(ventaID).val("0.00");
                    return;
                }
                var precioVenta = costo * (1 + (ganancia / 100));
                $(ventaID).val(precioVenta.toFixed(2));
            }

            $(costoID).off('keyup change', calcularPrecioVenta).on('keyup change', calcularPrecioVenta);
            $(gananciaID).off('keyup change', calcularPrecioVenta).on('keyup change', calcularPrecioVenta);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="min-h-screen w-full bg-slate-50/50 dark:bg-slate-900/50 p-4 sm:p-8">
        
        <div class="max-w-5xl mx-auto">
            
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
                <div>
                    <h1 class="text-3xl font-black text-slate-900 dark:text-white tracking-tight">
                        <asp:Label ID="lblTitulo" runat="server" Text="Nuevo Producto"></asp:Label>
                    </h1>
                    <p class="text-slate-500 dark:text-slate-400 mt-1">Completa la ficha técnica del artículo.</p>
                </div>
                <asp:HyperLink ID="lnkVolver" runat="server" NavigateUrl="~/ProductosListados.aspx" 
                    CssClass="text-sm font-medium text-slate-500 hover:text-primary transition-colors flex items-center gap-1">
                    <span class="material-symbols-outlined text-lg">arrow_back</span> Volver al listado
                </asp:HyperLink>
            </div>

            <asp:UpdatePanel ID="UpdatePanelMensajes" runat="server">
                <ContentTemplate>
                    <div class="mb-6">
                        <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" class="p-4 rounded-lg block border shadow-sm"></asp:Label>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                <div class="lg:col-span-2 flex flex-col gap-6">
                    
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 p-6">
                        <h2 class="text-lg font-bold text-slate-800 dark:text-white mb-4 flex items-center gap-2 border-b border-slate-100 dark:border-slate-700 pb-2">
                            <span class="material-symbols-outlined text-primary">inventory_2</span> Información Básica
                        </h2>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Nombre del Producto <span class="text-red-500">*</span></label>
                                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white transition-all font-medium" placeholder="Ej: Monitor LED 24 Pulgadas"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDescripcion" ErrorMessage="La descripción es obligatoria." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">SKU / Código</label>
                                <div class="relative">
                                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                        <span class="material-symbols-outlined text-slate-400 text-[20px]">qr_code</span>
                                    </div>
                                    <asp:TextBox ID="txtSKU" runat="server" ReadOnly="true" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-100 text-slate-500 pl-10 cursor-not-allowed dark:bg-slate-800 dark:border-slate-600 dark:text-slate-400" placeholder="Autogenerado"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 p-6">
                        <h2 class="text-lg font-bold text-slate-800 dark:text-white mb-4 flex items-center gap-2 border-b border-slate-100 dark:border-slate-700 pb-2">
                            <span class="material-symbols-outlined text-primary">payments</span> Precios y Costos
                        </h2>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 items-start">
                            
                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Costo ($) <span class="text-red-500">*</span></label>
                                <div class="relative">
                                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                        <span class="text-slate-400 font-bold">$</span>
                                    </div>
                                    <asp:TextBox ID="txtPrecioCostoActual" runat="server" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 pl-8 focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white" placeholder="0.00"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPrecioCostoActual" ErrorMessage="Requerido." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                                <asp:RangeValidator runat="server" ControlToValidate="txtPrecioCostoActual" MinimumValue="0" MaximumValue="9999999" Type="Double" ErrorMessage="Inválido." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Margen (%) <span class="text-red-500">*</span></label>
                                <div class="relative">
                                    <asp:TextBox ID="txtPorcentajeGanancia" runat="server" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 pr-8 text-right focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white" placeholder="30"></asp:TextBox>
                                    <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
                                        <span class="text-slate-400 font-bold">%</span>
                                    </div>
                                </div>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPorcentajeGanancia" ErrorMessage="Requerido." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                            <div class="sm:col-span-1 bg-primary/5 rounded-xl p-4 border border-primary/10">
                                <label class="block text-xs font-bold text-primary uppercase tracking-wider mb-1">Precio Venta</label>
                                <div class="flex items-center">
                                    <span class="text-lg font-medium text-primary mr-1">$</span>
                                    <asp:TextBox ID="txtPrecioVenta" runat="server" ReadOnly="true" CssClass="w-full bg-transparent border-none p-0 text-2xl font-black text-primary focus:ring-0" placeholder="0.00"></asp:TextBox>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>

                <div class="flex flex-col gap-6">
                    
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 p-6">
                        <h2 class="text-sm font-bold text-slate-500 uppercase tracking-wider mb-4">Clasificación</h2>
                        
                        <div class="flex flex-col gap-4">
                            
                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Marca <span class="text-red-500">*</span></label>
                                <asp:DropDownList ID="ddlMarca" runat="server" CssClass="form-select w-full rounded-lg border-slate-300 bg-slate-50 text-sm focus:border-primary focus:ring-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white"></asp:DropDownList>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlMarca" InitialValue="0" ErrorMessage="Seleccione una marca." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Categoría <span class="text-red-500">*</span></label>
                                <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-select w-full rounded-lg border-slate-300 bg-slate-50 text-sm focus:border-primary focus:ring-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white"></asp:DropDownList>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCategoria" InitialValue="0" ErrorMessage="Seleccione una categoría." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Proveedor <span class="text-red-500">*</span></label>
                                <asp:DropDownList ID="ddlProveedor" runat="server" CssClass="form-select w-full rounded-lg border-slate-300 bg-slate-50 text-sm focus:border-primary focus:ring-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white"></asp:DropDownList>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlProveedor" InitialValue="0" ErrorMessage="Seleccione un proveedor." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                        </div>
                    </div>

                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 p-6">
                        <h2 class="text-sm font-bold text-slate-500 uppercase tracking-wider mb-4">Inventario</h2>
                        
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Actual</label>
                                <asp:TextBox ID="txtStockActual" runat="server" TextMode="Number" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 text-center focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white" placeholder="0"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStockActual" ErrorMessage="*" CssClass="text-red-500 text-xs font-bold block text-center" Display="Dynamic" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Mínimo</label>
                                <asp:TextBox ID="txtStockMinimo" runat="server" TextMode="Number" CssClass="form-input w-full rounded-lg border-red-200 bg-red-50 text-center focus:bg-white focus:ring-red-500 focus:border-red-500 dark:bg-slate-900/50 dark:border-red-900/30 dark:text-white" placeholder="0"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStockMinimo" ErrorMessage="*" CssClass="text-red-500 text-xs font-bold block text-center" Display="Dynamic" />
                            </div>
                        </div>
                    </div>

                </div>

            </div>

            <div class="mt-8 flex justify-end gap-3 pt-6 border-t border-slate-200 dark:border-slate-700">
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" PostBackUrl="~/ProductosListados.aspx" CausesValidation="false"
                    CssClass="rounded-xl border border-slate-300 bg-white px-6 py-2.5 text-sm font-bold text-slate-700 hover:bg-slate-50 hover:text-slate-800 transition-all dark:border-slate-600 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700 cursor-pointer" />

                <asp:Button ID="btnGuardar" runat="server" Text="Guardar Producto" OnClick="btnGuardar_Click"
                    CssClass="rounded-xl bg-primary px-6 py-2.5 text-sm font-bold text-white shadow-lg shadow-primary/30 hover:bg-primary/90 hover:scale-[1.02] active:scale-95 transition-all cursor-pointer" />
            </div>

        </div>
    </div>
</asp:Content>
