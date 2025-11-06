<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GestionStock.aspx.cs" Inherits="Presentacion.GestionStock" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-7xl mx-auto">
        
        <!-- 1. Título de la Página -->
        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Gestión de Stock</h1>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Ajusta cantidades y revisa el historial de movimientos.</p>
            </div>
             <!-- Botón para volver al listado -->
            <asp:Button ID="btnVolver" runat="server" Text="⬅️ Volver al Listado" 
                PostBackUrl="~/ProductosListado.aspx" CausesValidation="false"
                CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-slate-200 dark:bg-slate-700 text-slate-700 dark:text-slate-200 text-sm font-bold leading-normal tracking-[0.015em] hover:bg-slate-300 dark:hover:bg-slate-600" />
        </div>

        <!-- 2. Información del Producto (bloqueadooo) -->
        <div class="bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-slate-900 dark:text-white text-lg font-bold leading-tight tracking-[-0.015em]">Información del Producto</h3>
                 <asp:Button ID="btnEditarAtributos" runat="server" Text="✏️ Editar Atributos" 
                    CausesValidation="false"
                    CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-9 px-3 bg-blue-100 dark:bg-blue-900 text-blue-700 dark:text-blue-200 text-sm font-bold leading-normal tracking-[0.015em] hover:bg-blue-200 dark:hover:bg-blue-800" 
                    OnClick="btnEditarAtributos_Click" />
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
                <!-- SKU (Bloqueado) -->
                <label class="flex flex-col flex-1 sm:col-span-1">
                    <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">SKU (Código)</p>
                    <asp:TextBox ID="txtSKU" runat="server" 
                        CssClass="form-input flex w-full ... h-11 bg-slate-100 dark:bg-slate-700/50" 
                        placeholder="SKU-00123" ReadOnly="true"></asp:TextBox>
                </label>
                <!-- Descripción (Bloqueado) -->
                <label class="flex flex-col flex-1 sm:col-span-2">
                    <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Descripción</p>
                    <asp:TextBox ID="txtDescripcion" runat="server" 
                        CssClass="form-input flex w-full ... h-11 bg-slate-100 dark:bg-slate-700/50" 
                        placeholder="Gaseosa Cola 2.25L" ReadOnly="true"></asp:TextBox>
                </label>
                 <!-- Stock Actual (Bloqueado) -->
                <label class="flex flex-col flex-1 sm:col-span-1">
                    <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Stock Actual</p>
                    <asp:TextBox ID="txtStockActual" runat="server" 
                        CssClass="form-input flex w-full ... h-11 bg-slate-100 dark:bg-slate-700/50 font-bold text-center" 
                        placeholder="150" ReadOnly="true"></asp:TextBox>
                </label>
            </div>
        </div>

        <!-- 3. Contenido (Formulario y Grilla) -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start mt-8">
            
            <!-- 3A. Formulario de Ajuste Manual -->
            <div class="lg:col-span-1 bg-white dark:bg-slate-800 p-6 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60">
                <div class="flex flex-col items-stretch justify-start mb-6">
                    <h3 class="text-slate-900 dark:text-white text-lg font-bold leading-tight tracking-[-0.015em]">Ajuste Manual de Stock</h3>
                    <p class="text-slate-500 dark:text-slate-400 text-sm font-normal leading-normal">Suma o resta stock por fuera de una compra/venta.</p>
                </div>
                
                <div class="flex flex-col gap-5">
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Tipo de Ajuste</p>
                        <asp:DropDownList ID="ddlTipoAjuste" runat="server" CssClass="form-select flex w-full ... h-11">
                            <asp:ListItem Value="Entrada" Selected="True">Entrada (Sumar stock)</asp:ListItem>
                            <asp:ListItem Value="Salida">Salida (Restar stock)</asp:ListItem>
                        </asp:DropDownList>
                    </label>
                    <label class="flex flex-col flex-1">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Cantidad</p>
                        <asp:TextBox ID="txtCantidadAjuste" runat="server" TextMode="Number"
                            CssClass="form-input flex w-full ... h-11" placeholder="0"></asp:TextBox>
                    </label>
                    <label class="flex flex-col">
                        <p class="text-slate-700 dark:text-slate-300 text-sm font-medium leading-normal pb-2">Motivo / Observación</p>
                        <asp:TextBox ID="txtMotivoAjuste" runat="server" TextMode="MultiLine" Rows="3" 
                            CssClass="form-textarea flex w-full ... min-h-24" placeholder="Ej: Rotura, Vencimiento, Ajuste de inventario..."></asp:TextBox>
                    </label>
                    <div class="flex items-center justify-end gap-3 mt-4">
                        <asp:Button ID="btnGuardarAjuste" runat="server" Text="Guardar Ajuste" 
                            CssClass="flex min-w-[84px] ... bg-primary text-white ... hover:bg-primary/90" />
                    </div>
                </div>
            </div>

            <!-- 3B. Historial de Movimientos -->
            <div class="lg:col-span-2">
                <div class="flex flex-col sm:flex-row items-center justify-between gap-4 mb-4">
                     <h3 class="text-slate-900 dark:text-white text-lg font-bold leading-tight tracking-[-0.015em]">Historial de Movimientos</h3>
                </div>
                
                <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60 overflow-hidden">
                    <div class="overflow-x-auto">
                        
                        <asp:GridView ID="gvMovimientos" runat="server" 
                            AutoGenerateColumns="False" 
                            CssClass="w-full text-sm text-left text-slate-500 dark:text-slate-400"
                            GridLines="None" AllowPaging="True" PageSize="5">
                            
                            <HeaderStyle CssClass="text-xs text-slate-700 ... uppercase bg-slate-50 ..." />
                            <RowStyle CssClass="bg-white ... border-b ... hover:bg-slate-50 ..." />
                            <PagerStyle CssClass="flex items-center justify-between p-4" />

                            <Columns>
                                <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:d}" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Tipo" HeaderText="Tipo" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Detalle" HeaderText="Detalle / Motivo" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" HeaderStyle-CssClass="px-6 py-3 text-right" ItemStyle-CssClass="px-6 py-4 text-right font-bold" />
                            </Columns>
                        </asp:GridView>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
