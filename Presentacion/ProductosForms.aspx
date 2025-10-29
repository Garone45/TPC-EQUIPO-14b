<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductosForms.aspx.cs" Inherits="Presentacion.ProductosForms" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
   <div class="max-w-4xl mx-auto">
        
        <!-- 1. Título de la Página -->
        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Agregar Nuevo Producto</h1>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Completa los atributos para crear un nuevo producto.</p>
            </div>
        </div>

        <!-- 2. Formulario de Carga -->
        <div class="lg:col-span-1 bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60">
            <div class="flex flex-col gap-5">
                
                <!-- Campos Principales (SKU y Descripción) -->
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    
                    
                    <label class="flex flex-col flex-1 sm:col-span-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">SKU (Código)</p>
                        <asp:TextBox ID="txtSKU" runat="server" 
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-slate-100 dark:bg-slate-700/50 h-11 placeholder:text-slate-400 dark:placeholder:text-slate-500 px-3 text-sm font-normal leading-normal" 
                            placeholder="Se generará automáticamente" 
                            ReadOnly="true"></asp:TextBox>
                    </label>
                    
                    <label class="flex flex-col flex-1 sm:col-span-2">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Descripción</p>
                        <asp:TextBox ID="txtDescripcion" runat="server" 
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-slate-700/50 h-11 placeholder:text-slate-400 dark:placeholder:text-slate-500 px-3 text-sm font-normal leading-normal" 
                            placeholder="Ej: Gaseosa Cola 2.25L"></asp:TextBox>
                    </label>
                </div>

                <!-- DropDowns (Marca y Categoría) -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Marca</p>
                        <asp:DropDownList ID="ddlMarca" runat="server" 
                            CssClass="form-select flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-slate-700/50 h-11 placeholder:text-slate-400 dark:placeholder:text-slate-500 pl-3 pr-8 text-sm font-normal leading-normal">
                            
                            <asp:ListItem Value="0" Selected="True" Disabled="True">-- Seleccionar Marca --</asp:ListItem>
                            <asp:ListItem Value="1">Marca A</asp:ListItem> 
                            <asp:ListItem Value="2">Marca B</asp:ListItem>
                        </asp:DropDownList>
                    </label>
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Categoría</p>
                        <asp:DropDownList ID="ddlCategoria" runat="server" 
                            CssClass="form-select flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-slate-700/50 h-11 placeholder:text-slate-400 dark:placeholder:text-slate-500 pl-3 pr-8 text-sm font-normal leading-normal">
                            
                            <asp:ListItem Value="0" Selected="True" Disabled="True">-- Seleccionar Categoría --</asp:ListItem>
                            <asp:ListItem Value="1">Categoría A</asp:ListItem>
                            <asp:ListItem Value="2">Categoría B</asp:ListItem>
                        </asp:DropDownList>
                    </label>
                </div>
                
                <!-- Campos Económicos (Precios y Ganancia) -->
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                     <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Precio de Compra ($)</p>
                        <asp:TextBox ID="txtPrecioCompra" runat="server" TextMode="Number" step="0.01" 
                            CssClass="form-input flex w-full ... h-11" placeholder="0.00"></asp:TextBox>
                    </label>
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Porcentaje Ganancia (%)</p>
                        <asp:TextBox ID="txtPorcentajeGanancia" runat="server" TextMode="Number" step="0.01"
                            CssClass="form-input flex w-full ... h-11" placeholder="0.00"></asp:TextBox>
                    </label>
                     <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Precio de Venta (Calculado)</p>
                        <asp:TextBox ID="txtPrecioVenta" runat="server" 
                            CssClass="form-input flex w-full ... h-11 bg-slate-100 dark:bg-slate-700/50" 
                            placeholder="0.00" ReadOnly="true"></asp:TextBox>
                    </label>
                </div>

                <!-- Campos de Stock -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                     <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Stock Actual</p>
                        <asp:TextBox ID="txtStockActual" runat="server" TextMode="Number" 
                            CssClass="form-input flex w-full ... h-11" placeholder="0" Text="0"></asp:TextBox>
                    </label>
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Stock Mínimo</p>
                        <asp:TextBox ID="txtStockMinimo" runat="server" TextMode="Number"
                            CssClass="form-input flex w-full ... h-11" placeholder="0" Text="0"></asp:TextBox>
                    </label>
                </div>

                <!-- Botones -->
                <div class="flex items-center justify-end gap-3 mt-4">
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" 
                        PostBackUrl="~/ProductosListado.aspx" CausesValidation="false"
                        CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-slate-200 dark:bg-slate-700 text-slate-700 dark:text-slate-200 text-sm font-bold leading-normal tracking-[0.015em] hover:bg-slate-300 dark:hover:bg-slate-600" />
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" 
                        CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
