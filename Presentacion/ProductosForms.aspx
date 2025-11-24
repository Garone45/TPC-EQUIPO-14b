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

    <div class="max-w-4xl mx-auto">

        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight">Gestión de Productos</h1>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal">Completa los datos del producto.</p>
            </div>
        </div>

        <asp:UpdatePanel ID="UpdatePanelMensajes" runat="server">
            <ContentTemplate>
                <div class="mb-4">
                    <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" class="p-4 rounded-lg block"></asp:Label>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div class="lg:col-span-1 bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60">
            <div class="flex flex-col gap-5">

                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">

                    <label class="flex flex-col flex-1 sm:col-span-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">SKU (Código)</span>
                        <asp:TextBox ID="txtSKU" runat="server" ReadOnly="true"
                            CssClass="form-input w-full rounded-lg border border-slate-300 bg-slate-100 px-3 py-2 text-sm"></asp:TextBox>
                    </label>

                    <label class="flex flex-col flex-1 sm:col-span-2">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Descripción *</span>
                        <asp:TextBox ID="txtDescripcion" runat="server"
                            CssClass="form-input w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDescripcion"
                            ErrorMessage="La descripción es obligatoria."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Marca *</span>
                        <asp:DropDownList ID="ddlMarca" runat="server"
                            CssClass="form-select w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm">
                        </asp:DropDownList>

                        <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlMarca"
                            InitialValue="0" ErrorMessage="Seleccione una marca."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Categoría *</span>
                        <asp:DropDownList ID="ddlCategoria" runat="server"
                            CssClass="form-select w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm">
                        </asp:DropDownList>

                        <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCategoria"
                            InitialValue="0" ErrorMessage="Seleccione una categoría."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>
                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Proveedor *</span>
                        <asp:DropDownList ID="ddlProveedor" runat="server"
                            CssClass="form-select w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm">
                        </asp:DropDownList>

                        <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlProveedor"
                            InitialValue="0" ErrorMessage="Seleccione un proveedor."
                            CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>

                </div>

                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Precio Compra ($) *</span>
                        <asp:TextBox ID="txtPrecioCostoActual" runat="server"
                            CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPrecioCostoActual"
                            ErrorMessage="Requerido." CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />

                        <asp:RangeValidator runat="server" ControlToValidate="txtPrecioCostoActual"
                            MinimumValue="0" MaximumValue="9999999" Type="Double"
                            ErrorMessage="Inválido." CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">% Ganancia *</span>
                        <asp:TextBox ID="txtPorcentajeGanancia" runat="server"
                            CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPorcentajeGanancia"
                            ErrorMessage="Requerido." CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />

                        <asp:RangeValidator runat="server" ControlToValidate="txtPorcentajeGanancia"
                            MinimumValue="0" MaximumValue="1000" Type="Double"
                            ErrorMessage="Inválido." CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Precio Venta</span>
                        <asp:TextBox ID="txtPrecioVenta" runat="server" ReadOnly="true"
                            CssClass="form-input w-full rounded-lg border border-slate-300 bg-slate-100 px-3 py-2 text-sm font-bold text-slate-900"></asp:TextBox>
                    </label>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Stock Actual *</span>
                        <asp:TextBox ID="txtStockActual" runat="server" TextMode="Number"
                            CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStockActual"
                            ErrorMessage="Requerido." CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />

                        <asp:RangeValidator runat="server" ControlToValidate="txtStockActual"
                            MinimumValue="0" MaximumValue="999999" Type="Integer"
                            ErrorMessage="Solo núm. enteros." CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>

                    <label class="flex flex-col flex-1">
                        <span class="text-slate-700 dark:text-slate-300 text-sm font-medium pb-2">Stock Mínimo *</span>
                        <asp:TextBox ID="txtStockMinimo" runat="server" TextMode="Number"
                            CssClass="form-input w-full rounded-lg border border-slate-300 px-3 py-2 text-sm"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStockMinimo"
                            ErrorMessage="Requerido." CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />

                        <asp:RangeValidator runat="server" ControlToValidate="txtStockMinimo"
                            MinimumValue="0" MaximumValue="999999" Type="Integer"
                            ErrorMessage="Solo núm. enteros." CssClass="text-red-500 text-xs mt-1 font-bold" Display="Dynamic" />
                    </label>
                </div>

                <div class="flex items-center justify-end gap-3 mt-4">
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar"
                        PostBackUrl="~/ProductosListados" CausesValidation="false"
                        CssClass="px-4 py-2 rounded-lg bg-slate-200 text-slate-700 font-bold hover:bg-slate-300 cursor-pointer" />

                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar"
                        OnClick="btnGuardar_Click"
                        CssClass="px-4 py-2 rounded-lg bg-blue-600 text-white font-bold hover:bg-blue-700 cursor-pointer" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
