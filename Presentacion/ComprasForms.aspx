<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ComprasForms.aspx.cs" Inherits="Presentacion.ComprasForms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    </asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="min-h-screen w-full bg-slate-50/50 dark:bg-slate-900/50 p-4 sm:p-6 lg:p-8">
        
        <div class="mx-auto max-w-6xl flex flex-col gap-6">

            <header class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-2">
                <div>
                    <h1 class="text-3xl font-black tracking-tight text-slate-900 dark:text-white">Registrar Compra</h1>
                    <p class="text-slate-500 dark:text-slate-400 mt-1">Ingresa los detalles de la factura y carga el stock.</p>
                </div>
                <div class="flex items-center gap-2">
                    <span class="px-3 py-1 rounded-full bg-blue-100 text-blue-700 text-xs font-bold uppercase tracking-wider">Nueva</span>
                    <span class="text-sm text-slate-400 font-mono">#<%: DateTime.Now.ToString("yyyyMMdd") %>-TMP</span>
                </div>
            </header>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                <div class="lg:col-span-2 flex flex-col gap-6">

                    <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm dark:border-slate-800 dark:bg-slate-900">
                        <h2 class="text-lg font-bold text-slate-800 dark:text-white mb-4 flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary">store</span> Datos del Proveedor
                        </h2>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            
                            <div class="col-span-2 md:col-span-1">
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Proveedor</label>
                                <div class="flex gap-2">
                                    <div class="relative flex-1">
                                        <asp:DropDownList ID="ddlProveedor" runat="server" CssClass="form-select w-full rounded-lg border-slate-300 bg-slate-50 text-sm focus:border-primary focus:ring-primary dark:border-slate-700 dark:bg-slate-800 dark:text-white h-11">
                                        </asp:DropDownList>
                                    </div>
                                    
                                </div>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Fecha de Emisión</label>
                                <div class="relative">
                                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                        <span class="material-symbols-outlined text-slate-400 text-lg">calendar_today</span>
                                    </div>
                                    <asp:TextBox ID="txtFechaCompra" runat="server" TextMode="Date" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 pl-10 text-sm focus:border-primary focus:ring-primary dark:border-slate-700 dark:bg-slate-800 dark:text-white h-11"></asp:TextBox>
                                </div>
                            </div>

                            <div class="col-span-2">
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">N° Factura / Referencia</label>
                                <div class="relative">
                                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                        <span class="material-symbols-outlined text-slate-400 text-lg">receipt_long</span>
                                    </div>
                                    <asp:TextBox ID="txtFacturaRef" runat="server" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 pl-10 text-sm focus:border-primary focus:ring-primary dark:border-slate-700 dark:bg-slate-800 dark:text-white h-11" placeholder="Ej: A-0001-00001234"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="rounded-2xl border border-slate-200 bg-white shadow-sm dark:border-slate-800 dark:bg-slate-900 overflow-hidden">
                        
                        <div class="bg-slate-50/50 dark:bg-slate-800/50 border-b border-slate-100 dark:border-slate-800 p-4 sm:p-6">
                             <h2 class="text-lg font-bold text-slate-800 dark:text-white flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary">inventory_2</span> Ítems de la Compra
                            </h2>
                        </div>

                        <div class="p-4 sm:p-6 bg-slate-50 dark:bg-slate-800/30 border-b border-slate-100 dark:border-slate-800">
                            <div class="grid grid-cols-12 gap-4 items-end">
                                
                                <div class="col-span-12 md:col-span-5">
                                    <label class="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Producto</label>
                                    <asp:DropDownList ID="ddlProductoItem" runat="server" CssClass="form-select w-full rounded-lg border-slate-300 text-sm h-10 focus:ring-2 focus:ring-primary/20 dark:bg-slate-800 dark:border-slate-600 dark:text-white"></asp:DropDownList>
                                </div>

                                <div class="col-span-6 md:col-span-2">
                                    <label class="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Cant.</label>
                                    <asp:TextBox ID="txtCantidad" runat="server" TextMode="Number" CssClass="form-input w-full rounded-lg border-slate-300 text-sm h-10 text-center dark:bg-slate-800 dark:border-slate-600 dark:text-white" placeholder="0"></asp:TextBox>
                                </div>

                                <div class="col-span-6 md:col-span-3">
                                    <label class="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Costo Unit.</label>
                                    <div class="relative">
                                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                            <span class="text-slate-400 text-sm">$</span>
                                        </div>
                                        <asp:TextBox ID="txtCosto" runat="server" TextMode="Number" CssClass="form-input w-full rounded-lg border-slate-300 pl-7 text-sm h-10 dark:bg-slate-800 dark:border-slate-600 dark:text-white" placeholder="0.00"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-span-12 md:col-span-2">
                                    <asp:LinkButton ID="btnAnadirProducto" runat="server" OnClick ="btnAnadirProducto_Click" CssClass="flex w-full items-center justify-center gap-2 rounded-lg bg-emerald-600 px-4 h-10 text-sm font-semibold text-white shadow-sm hover:bg-emerald-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-emerald-600 transition-all">                                        
                                        <span class="material-symbols-outlined text-[20px]">add</span> Añadir
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>

                        <div class="overflow-x-auto">
    <asp:GridView ID="gvDetalleCompra" runat="server" AutoGenerateColumns="false" GridLines="None"
        CssClass="w-full text-left border-collapse"
        HeaderStyle-CssClass="bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-700"
        RowStyle-CssClass="border-b border-slate-50 dark:border-slate-800 hover:bg-slate-50/50 dark:hover:bg-slate-800/50 transition-colors"
        EmptyDataText="No hay productos cargados."
        OnRowCommand="gvDetalleCompra_RowCommand"
        ShowHeaderWhenEmpty="true">
        <Columns>
            <asp:TemplateField HeaderText="PRODUCTO">
                <HeaderStyle CssClass="py-3 pl-6 pr-3 text-xs font-bold uppercase tracking-wide text-slate-500" />
                <ItemTemplate>
                    <div class="pl-6 py-3">
                        <p class="font-semibold text-slate-900 dark:text-white"><%# Eval("NombreProducto") %></p>
                        <p class="text-xs text-slate-400">SKU: <%# Eval("IDArticulo") %></p>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="CANT.">
                <HeaderStyle CssClass="px-3 py-3 text-center text-xs font-bold uppercase tracking-wide text-slate-500" />
                <ItemTemplate>
                    <div class="text-center">
                        <span class="inline-flex items-center rounded-md bg-slate-100 px-2 py-1 text-xs font-medium text-slate-600 dark:bg-slate-800 dark:text-slate-400">
                            <%# Eval("Cantidad") %>
                        </span>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="PrecioUnitario" HeaderText="COSTO" DataFormatString="{0:C}">
                <HeaderStyle CssClass="px-3 py-3 text-right text-xs font-bold uppercase tracking-wide text-slate-500" />
                <ItemStyle CssClass="px-3 py-3 text-right text-sm text-slate-600 dark:text-slate-300" />
            </asp:BoundField>

            <asp:BoundField DataField="Subtotal" HeaderText="SUBTOTAL" DataFormatString="{0:C}">
                <HeaderStyle CssClass="px-3 py-3 text-right text-xs font-bold uppercase tracking-wide text-slate-500" />
                <ItemStyle CssClass="px-3 py-3 text-right text-sm font-bold text-slate-900 dark:text-white" />
            </asp:BoundField>

            <asp:TemplateField>
                <HeaderStyle CssClass="w-10" />
                <ItemTemplate>
                    <div class="pr-6 text-right">
                        <asp:LinkButton ID="btnEliminarProducto" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("IDDetalle") %>' CssClass="text-slate-400 hover:text-red-500 transition-colors">
                            <span class="material-symbols-outlined text-[20px]">delete</span>
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="p-8 text-center text-slate-400">
                <span class="material-symbols-outlined text-4xl mb-2 opacity-50">shopping_bag</span>
                <p class="text-sm">Aún no has agregado productos a esta compra.</p>
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
                    </section>
                </div>

                <div class="lg:col-span-1">
                    <div class="sticky top-6 flex flex-col gap-6">
                        
                        <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm dark:border-slate-800 dark:bg-slate-900">
                            <h3 class="text-sm font-bold text-slate-500 uppercase tracking-wider mb-3">Notas Adicionales</h3>
                            <div class="relative">
                                <asp:TextBox ID="txtObservaciones" runat="server" TextMode="MultiLine" Rows="3" 
                                    CssClass="form-textarea w-full rounded-lg border-slate-300 bg-slate-50 text-sm focus:border-primary focus:ring-primary dark:border-slate-700 dark:bg-slate-800 dark:text-white resize-none" 
                                    placeholder="Escribe aquí observaciones sobre la entrega, estado de los productos, etc."></asp:TextBox>
                                <div class="absolute bottom-2 right-2 pointer-events-none">
                                    <span class="material-symbols-outlined text-slate-400 text-sm">edit_note</span>
                                </div>
                            </div>
                        </section>

                        <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-lg shadow-slate-200/50 dark:border-slate-800 dark:bg-slate-900 dark:shadow-none">
                            <h3 class="text-sm font-bold text-slate-500 uppercase tracking-wider mb-4">Resumen</h3>
                            
                            <div class="space-y-3">
                                <div class="flex justify-between text-sm text-slate-600 dark:text-slate-400">
                                    <span>Subtotal</span>
                                    <asp:Label ID="lblSubtotal" runat="server" CssClass="font-medium" Text="$0.00"></asp:Label>                                
                                </div>
                                <div class="flex justify-between text-sm text-slate-600 dark:text-slate-400">
                                    <span>Impuestos</span>
                                    <span class="font-medium">$0.00</span>
                                </div>
                                
                                <div class="my-4 border-t border-dashed border-slate-200 dark:border-slate-700"></div>
                                
                                <div class="flex justify-between items-end">
                                    <span class="text-base font-bold text-slate-800 dark:text-white">Total</span>
                                    <asp:Label ID="lblTotalPagar" runat="server" CssClass="text-3xl font-black text-primary" ></asp:Label>
                                </div>
                            </div>

                            <div class="mt-8 flex flex-col gap-3">
                                <asp:Button ID="btnGuardarCompra" runat="server" Text="Confirmar Compra" OnClick="btnGuardarCompra_Click"  CssClass="w-full cursor-pointer rounded-xl bg-primary px-4 py-3.5 text-sm font-bold text-white shadow-lg shadow-primary/30 hover:bg-primary/90 hover:scale-[1.02] active:scale-95 transition-all" />
                                
                                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar Operación" OnClick="btnCancelar_Click" CssClass="w-full cursor-pointer rounded-xl border border-transparent px-4 py-3.5 text-sm font-bold text-slate-500 hover:bg-red-50 hover:text-red-600 transition-colors" />
                            </div>
                        </section>

                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>