<%@ Page Title="Listado de Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductosListados.aspx.cs" Inherits="Presentacion.ProductosListados" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script src="Scripts/jquery-3.7.0.min.js"></script>

    <script src="Scripts/bootstrap.bundle.min.js"></script>


    <style>
        /* Aseguramos que los encabezados sean posicionables para los 'resizers' */
        .resizable th {
            position: relative;
            overflow: hidden; /* Importante para que el resizer no se salga */
            text-overflow: ellipsis;
        }

            .resizable th .resizer {
                width: 5px;
                height: 100%;
                position: absolute;
                right: 0;
                top: 0;
                cursor: col-resize;
                user-select: none;
                z-index: 10;
                /* Un color suave al pasar el mouse para que el usuario sepa que está ahí */
                border-right: 2px solid transparent;
            }

                .resizable th .resizer:hover {
                    border-right: 2px solid #ccc;
                }

        /* CORRECCIÓN PRINCIPAL: fixed layout */
        #gvProductos table {
            table-layout: fixed !important;
            width: 100% !important; /* Ocupar el ancho disponible */
            border-collapse: collapse;
        }

            /* Opcional: Para que las celdas también respeten el ancho y corten texto */
            #gvProductos table td {
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-7xl mx-auto">

        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Gestión de Productos</h1>
            </div>
        </div>

        <asp:UpdatePanel ID="upnlGrillaProductos" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:HiddenField ID="hfIdProducto" runat="server" ClientIDMode="Static" />
                <asp:Button ID="btnEliminarServer" runat="server" OnClick="btnEliminarServer_Click" Style="display: none;" ClientIDMode="Static" />

                <div class="flex flex-col sm:flex-row items-center justify-between gap-4 mb-4">
                    <div class="relative w-full sm:max-w-xs">
                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                            <span class="material-symbols-outlined text-slate-400">search</span>
                        </div>
                        <asp:TextBox ID="txtBuscar" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-10 placeholder:text-slate-400 dark:placeholder:text-slate-500 pl-10 pr-4 text-sm font-normal leading-normal"
                            placeholder="Buscar por SKU o Descripción..."
                            onkeyup="delayPostback(this);"
                            OnTextChanged="txtBuscar_TextChanged" />
                    </div>
                    <asp:Button ID="btnNuevo" runat="server" Text="➕ Agregar Producto"
                        PostBackUrl="~/ProductosForms.aspx"
                        CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90" />
                </div>

                <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60 overflow-hidden">
                    <div class="overflow-x-auto" style="display: block; width: 100%;">
                        <asp:GridView ID="gvProductos" runat="server"
                            AutoGenerateColumns="False"
                            DataKeyNames="IDArticulo"
                            CssClass="resizable"
                            GridLines="None"
                            AllowPaging="True" PageSize="10"
                            AllowSorting="True"
                            OnSorting="gvProductos_Sorting"
                            OnPageIndexChanging="gvProductos_PageIndexChanging">

                            <HeaderStyle CssClass="text-xs text-slate-700 dark:text-slate-300 uppercase bg-slate-50 dark:bg-slate-700/50 cursor-pointer" />
                            <RowStyle CssClass="bg-white dark:bg-slate-800 border-b dark:border-slate-700/60 hover:bg-slate-50 dark:hover:bg-slate-700/40" />
                            <PagerStyle CssClass="flex items-center justify-between p-4" />

                            <Columns>
                                <asp:BoundField DataField="IDArticulo" HeaderText="SKU" SortExpression="IDArticulo" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" />
                                <asp:BoundField DataField="Descripcion" HeaderText="Descripción" SortExpression="Descripcion" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" />
                                <asp:BoundField DataField="Marca.Descripcion" HeaderText="Marca" SortExpression="Marca" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Categorias.descripcion" HeaderText="Categoría" SortExpression="Categoria" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="PrecioVentaCalculado" HeaderText="Precio Venta" SortExpression="PrecioVentaCalculado" DataFormatString="$ {0:N2}" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 text-right font-bold text-green-600" />
                                <asp:TemplateField HeaderText="Proveedor" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4">
                                    <ItemTemplate>
                                        <%# Eval("Proveedor.RazonSocial") %>
                                    </ItemTemplate>
                                </asp:TemplateField>


                                <asp:BoundField DataField="StockActual" HeaderText="Stock" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center font-bold" />

                                <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center">
                                    <ItemTemplate>
                                        <div class="flex justify-center gap-2">
                                            <asp:HyperLink ID="lnkEditar" runat="server"
                                                NavigateUrl='<%# "~/ProductosForms.aspx?id=" + Eval("IDArticulo") %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-primary/10 hover:text-primary dark:hover:bg-primary/20">
                                                <span class="material-symbols-outlined text-lg">edit</span>
                                            </asp:HyperLink>

                                            <a href="javascript:void(0);"
                                                onclick="abrirModalEliminar(<%# Eval("IDArticulo") %>);"
                                                class="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-red-500/10 hover:text-red-500 dark:hover:bg-red-500/20 cursor-pointer">
                                                <span class="material-symbols-outlined text-lg">delete</span>
                                            </a>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                    </div>
                </div>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="txtBuscar" EventName="TextChanged" />
            </Triggers>
        </asp:UpdatePanel>

        <div class="modal fade" id="modalEliminar" tabindex="-1" aria-hidden="true" style="display: none;">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 400px;">

                <div class="modal-content border-0 shadow-2xl overflow-hidden"
                    style="border-radius: 1rem; border: 2px solid #1173d4;">

                    <div class="bg-primary text-white px-4 py-2 flex justify-between items-center">
                        <span class="font-bold text-sm tracking-wide">CONFIRMACIÓN</span>
                        <button type="button" class="btn-close btn-close-white text-xs" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body text-center pt-6 pb-4 px-4 bg-white dark:bg-slate-800">
                        <div class="mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-blue-50 dark:bg-blue-900/20">
                            <span class="material-symbols-outlined text-3xl text-primary">delete</span>
                        </div>

                        <h3 class="text-lg font-bold text-slate-800 dark:text-white">¿Borrar producto?</h3>
                        <p class="text-slate-500 text-sm mt-1 leading-snug">
                           Baja logica del producto.
                        </p>
                    </div>

                    <div class="flex gap-2 p-3 bg-slate-50 dark:bg-slate-800/50 justify-center">
                        <button type="button"
                            class="px-4 py-1.5 rounded text-sm text-slate-600 font-medium hover:bg-slate-200 transition-colors"
                            data-bs-dismiss="modal">
                            Cancelar
                        </button>
                        <button type="button"
                            class="px-4 py-1.5 rounded text-sm bg-primary text-white font-bold hover:bg-blue-600 shadow-md transition-colors"
                            onclick="ejecutarBorradoServer()">
                            Sí, eliminar
                        </button>
                    </div>

                </div>
            </div>
        </div>

    </div>
    <div class="modal fade" id="mensajeModal" tabindex="-1" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 400px;">
        <div class="modal-content border-0 shadow-2xl overflow-hidden" style="border-radius: 1rem;">
            
            <div id="modalHeader" class="px-4 py-2 flex justify-between items-center bg-gray-600 text-white">
                <span id="modalTitulo" class="font-bold text-sm tracking-wide">MENSAJE</span>
                <button type="button" class="btn-close btn-close-white text-xs" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body text-center pt-6 pb-4 px-4 bg-white dark:bg-slate-800">
                <div id="modalIconoContainer" class="mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-gray-100">
                    <span id="modalIcono" class="material-symbols-outlined text-3xl text-gray-600">info</span>
                </div>
                
                <h3 id="modalTextoPrincipal" class="text-lg font-bold text-slate-800 dark:text-white">Aviso</h3>
                <p id="modalTextoSecundario" class="text-slate-500 text-sm mt-1 leading-snug">
                    ...
                </p>
            </div>

            <div class="flex gap-2 p-3 bg-slate-50 dark:bg-slate-800/50 justify-center">
                <button type="button" 
                        class="px-6 py-1.5 rounded text-sm bg-slate-700 text-white font-bold hover:bg-slate-800 shadow-md transition-colors"
                        data-bs-dismiss="modal">
                    Entendido
                </button>
            </div>

        </div>
    </div>
</div>

    <script type="text/javascript">
        // 1. Función para abrir el modal
        var modalEliminar;

        function abrirModalEliminar(id) {
            // 1. Asignar ID al HiddenField (Usamos el ID estático)
            var hf = document.getElementById('hfIdProducto');
            if (hf) {
                hf.value = id;
            }

            // 2. Abrir Modal usando JavaScript Nativo (Bootstrap 5)
            var elementoModal = document.getElementById('modalEliminar');

            // Creamos la instancia si no existe, o la recuperamos
            if (!modalEliminar) {
                modalEliminar = new bootstrap.Modal(elementoModal);
            }

            modalEliminar.show();
        }

        function ejecutarBorradoServer() {
            // 1. Ocultar modal
            if (modalEliminar) {
                modalEliminar.hide();
            }

            // 2. Click en el botón del servidor
            var btn = document.getElementById('btnEliminarServer');
            if (btn) {
                btn.click();
            }
        }

        // --- Funciones de Búsqueda (No tocar) ---
        var delayTimer;
        function delayPostback(source) {
            clearTimeout(delayTimer);
            delayTimer = setTimeout(function () { __doPostBack(source.name, ''); }, 500);
        }
        function setFocusAfterUpdate() {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function (sender, args) {
                if (args.get_error() == null) {
                    var focusedControl = $get('<%= txtBuscar.ClientID %>');
                    if (focusedControl) {
                        var val = focusedControl.value;
                        focusedControl.focus();
                        focusedControl.value = ''; focusedControl.value = val;
                    }
                }
            });
        }
        try { if (typeof Sys !== 'undefined') setFocusAfterUpdate(); } catch (e) { }
        function mostrarMensaje(titulo, mensaje, tipo) {
            var header = document.getElementById('modalHeader');
            var tituloEl = document.getElementById('modalTitulo');
            var iconoContainer = document.getElementById('modalIconoContainer');
            var icono = document.getElementById('modalIcono');
            var textoPrincipal = document.getElementById('modalTextoPrincipal');
            var textoSecundario = document.getElementById('modalTextoSecundario');

            // Configuración visual según tipo
            if (tipo === 'error') {
                header.className = "px-4 py-2 flex justify-between items-center bg-red-600 text-white";
                iconoContainer.className = "mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-red-100";
                icono.className = "material-symbols-outlined text-3xl text-red-600";
                icono.innerText = "warning";
            } else {
                // Success
                header.className = "px-4 py-2 flex justify-between items-center bg-green-600 text-white";
                iconoContainer.className = "mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-green-100";
                icono.className = "material-symbols-outlined text-3xl text-green-600";
                icono.innerText = "check_circle";
            }

            tituloEl.innerText = tipo === 'error' ? "ERROR" : "ÉXITO";
            textoPrincipal.innerText = titulo;
            textoSecundario.innerText = mensaje;

            // Mostrar modal
            var el = document.getElementById('mensajeModal');
            if (window.bootstrap && window.bootstrap.Modal) {
                var myModal = bootstrap.Modal.getOrCreateInstance(el);
                myModal.show();
            }
        }

    </script>

    <script type="text/javascript">
        (function () {

            function inicializarResize() {
                try {
                    // Obtener el GridView
                    var grid = document.getElementById('<%= gvProductos.ClientID %>');
                    if (!grid) return;

                    // Buscar la tabla real (ASP.NET a veces renderiza un div contenedor)
                    var table = (grid.tagName && grid.tagName.toLowerCase() === 'table') ? grid : grid.querySelector('table');
                    if (!table) return;

                    // --- CORRECCIÓN CRÍTICA ---
                    // Forzamos el layout fixed para que obedezca nuestros anchos en pixeles
                    table.style.tableLayout = 'fixed';

                    // Si la tabla no tiene ancho definido, el fixed layout colapsa.
                    // Aseguramos que tenga el ancho actual calculado antes de empezar.
                    if (table.clientWidth) {
                        table.style.width = table.clientWidth + "px";
                    }

                    // Limpiar resizers previos para evitar duplicados en postbacks
                    var oldResizers = table.querySelectorAll('.resizer');
                    for (var i = 0; i < oldResizers.length; i++) {
                        oldResizers[i].parentNode.removeChild(oldResizers[i]);
                    }

                    // Obtener THs de la primera fila (header)
                    var ths = table.querySelectorAll('th');

                    // Asignar el ancho computado actual como estilo inline fijo
                    // Esto es vital para que al cambiar de 'auto' a 'fixed' no salten las columnas
                    ths.forEach(function (th) {
                        var width = th.offsetWidth;
                        th.style.width = width + "px";

                        // Crear el div resizer
                        var resizer = document.createElement('div');
                        resizer.className = 'resizer';
                        th.appendChild(resizer);

                        createResizableColumn(th, resizer);
                    });

                } catch (err) {
                    console.error('Error inicializarResize:', err);
                }
            }

            function createResizableColumn(th, resizer) {
                var x = 0;
                var w = 0;

                var mouseDownHandler = function (e) {
                    // Guardar posición inicial
                    x = e.clientX; // Usar clientX es más seguro que pageX para fixed layouts

                    var styles = window.getComputedStyle(th);
                    w = parseInt(styles.width, 10);

                    document.addEventListener('mousemove', mouseMoveHandler);
                    document.addEventListener('mouseup', mouseUpHandler);

                    resizer.classList.add('resizing');
                    document.body.style.cursor = 'col-resize';
                    document.body.style.userSelect = 'none'; // Evitar seleccionar texto mientras arrastras
                };

                var mouseMoveHandler = function (e) {
                    var dx = e.clientX - x;
                    var newWidth = w + dx;

                    // Evitar que la columna sea invisible (mínimo 50px)
                    if (newWidth > 50) {
                        th.style.width = newWidth + 'px';
                    }
                };

                var mouseUpHandler = function () {
                    document.removeEventListener('mousemove', mouseMoveHandler);
                    document.removeEventListener('mouseup', mouseUpHandler);

                    resizer.classList.remove('resizing');
                    document.body.style.cursor = '';
                    document.body.style.userSelect = '';
                };

                resizer.addEventListener('mousedown', mouseDownHandler);
            }

            // Ejecutar al cargar
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', inicializarResize);
            } else {
                inicializarResize();
            }

            // Re-ejecutar tras UpdatePanel
            try {
                if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                        // Pequeño delay para asegurar que el DOM del UpdatePanel se pintó
                        setTimeout(inicializarResize, 50);
                    });
                }
            } catch (e) { }

        })();
    </script>
</asp:Content>
