USE SIMEXPRO
GO


/* PROCEDIMIENTOS tb.FacturasExportacion*/

 -- PROCEDIMIENTO PARA LISTAR LAS FACTURAS EXPORTACION
CREATE OR ALTER PROCEDURE Prod.UDP_tbFacturasExportacion_Listar
AS
	BEGIN
		SELECT	FactExport.faex_Id, 
				FactExport.duca_No_Duca, 
				FactExport.faex_Fecha, 
				FactExport.orco_Id, 
				CONCAT('No. ', PO.orco_Id, ' - ', Clie.clie_Nombre_O_Razon_Social, ' - ', CONVERT(DATE, PO.orco_FechaEmision)) AS orco_Descripcion,
				
				FactExport.faex_Total, 
				Clie.clie_Nombre_O_Razon_Social,
				FactExport.usua_UsuarioCreacion, 
				UserCrea.usua_Nombre	AS usuarioCreacionNombre,
				FactExport.faex_FechaCreacion, 
				FactExport.usua_UsuarioModificacion,
				UserModifica.usua_Nombre AS usuarioModificacionNombre, 
				FactExport.faex_FechaModificacion,
				FactExport.faex_Finalizado,
				FactExport.faex_Estado,
				(SELECT	FactExportDetails.fede_Id, 
						FactExportDetails.faex_Id, 
						FactExportDetails.code_Id, 
						PODetail.code_CantidadPrenda, 
						Style.esti_Descripcion,
						Talla.tall_Codigo,
						PODetail.code_Sexo, 
						Color.colr_Nombre,
						PODetail.code_Unidad, 
						PODetail.code_Valor, 
						PODetail.code_Impuesto, 
						PODetail.code_EspecificacionEmbalaje,
						FactExportDetails.fede_Cajas, 
						FactExportDetails.fede_Cantidad, 
						FactExportDetails.fede_PrecioUnitario, 
						FactExportDetails.fede_TotalDetalle,
						CONCAT('#: ', PODetail.code_CodigoDetalle, ' - ',Style.esti_Descripcion,' - ',Talla.tall_Codigo,' - ',PODetail.code_Sexo,' - ',Color.colr_Nombre) AS code_Descripcion 
				FROM Prod.tbFacturasExportacionDetalles AS FactExportDetails
				INNER JOIN Prod.tbOrdenCompraDetalles AS PODetail ON FactExportDetails.code_Id = PODetail.code_Id
				INNER JOIN Prod.tbEstilos AS Style ON PODetail.esti_Id = Style.esti_Id
				INNER JOIN Prod.tbTallas AS Talla ON PODetail.tall_Id = Talla.tall_Id
				INNER JOIN Prod.tbColores AS Color ON PODetail.colr_Id = Color.colr_Id
				WHERE FactExportDetails.faex_Id = FactExport.faex_Id
				FOR JSON PATH) AS Detalles
		FROM	Prod.tbFacturasExportacion		AS FactExport
		INNER JOIN Prod.tbOrdenCompra		AS PO			ON FactExport.orco_Id = PO.orco_Id
		INNER JOIN Prod.tbClientes			AS Clie			ON PO.orco_IdCliente = Clie.clie_Id
		INNER JOIN Acce.tbUsuarios			AS UserCrea		ON FactExport.usua_UsuarioCreacion = UserCrea.usua_Id
		LEFT JOIN Acce.tbUsuarios			AS UserModifica ON FactExport.usua_UsuarioModificacion = UserModifica.usua_Id
		WHERE FactExport.faex_Estado = 1
	END
GO

-- PROCEDIMIENTO PARA INSERTAR LAS FACTURAS EXPORTACION (ENCABEZADO)
CREATE OR ALTER PROCEDURE Prod.UDP_tbFacturasExportacion_Insertar --'12345678696', '08/31/2023', 2, 3, '08/31/2023'
	@duca_No_Duca			NVARCHAR(100),
	@faex_Fecha				DATETIME, 
	@orco_Id				INT, 
	@usua_UsuarioCreacion	INT, 
	@faex_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
		INSERT INTO Prod.tbFacturasExportacion(duca_No_Duca, faex_Fecha, orco_Id, 
												faex_Total, usua_UsuarioCreacion, faex_FechaCreacion)
		VALUES(@duca_No_Duca, @faex_Fecha, @orco_Id, 0, @usua_UsuarioCreacion, @faex_FechaCreacion)

		DECLARE @faex_Id INT = SCOPE_IDENTITY();

		SELECT @faex_Id 
	END TRY

	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO


-- PROCEDIMIENTO PARA EDITAR LAS FACTURAS EXPORTACION (ENCABEZADO)
CREATE OR ALTER PROCEDURE Prod.UDP_tbFacturasExportacion_Editar
	@faex_Id					INT, 
	@duca_No_Duca				NVARCHAR(100), 
	@faex_Fecha					DATETIME, 
	@orco_Id					INT,   
	@usua_UsuarioModificacion	INT, 
	@faex_FechaModificacion		DATETIME
AS
BEGIN 
	BEGIN TRY
		
		DECLARE @prev_orco_Id INT =	(SELECT orco_Id FROM Prod.tbFacturasExportacion WHERE faex_Id = @faex_Id)
		
		IF @prev_orco_Id != @orco_Id
			BEGIN

				/* Debido a que el usuario cambio de �rden de compra en el encabezado,
				los items a�adidos con la orden de compra previa ser�n eliminados */
				DELETE FROM Prod.tbFacturasExportacionDetalles
				WHERE faex_Id = @faex_Id


				UPDATE Prod.tbFacturasExportacion
				SET	duca_No_Duca = @duca_No_Duca, 
					faex_Fecha = @faex_Fecha, 
					orco_Id = @orco_Id, 
					usua_UsuarioModificacion = @usua_UsuarioModificacion, 
					faex_FechaModificacion = @faex_FechaModificacion
				WHERE faex_Id = @faex_Id

				SELECT 1
			END
		ELSE
			BEGIN
				UPDATE Prod.tbFacturasExportacion
				SET	duca_No_Duca = @duca_No_Duca, 
					faex_Fecha = @faex_Fecha, 
					orco_Id = @orco_Id, 
					usua_UsuarioModificacion = @usua_UsuarioModificacion, 
					faex_FechaModificacion = @faex_FechaModificacion
				WHERE faex_Id = @faex_Id

				SELECT 1
			END
	END TRY

	BEGIN CATCH 
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO


-- PROCEDIMIENTO PARA ESTABLECER EL ESTADO DE LAS FACTURAS EXPORTACION A 0 (DESHABILITADO)
CREATE OR ALTER PROC Prod.UDP_tbFacturasExportacion_Eliminar
	@faex_Id  		INT
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'faex_Id  ', @faex_Id  , 'Prod.tbFacturasExportacion', @respuesta OUTPUT

			IF(@respuesta) = 1
					BEGIN
				UPDATE [Prod].[tbFacturasExportacion]
				SET	   faex_Estado = 0
				WHERE  faex_Id = @faex_Id  

				END
			SELECT @respuesta AS Resultado
	END TRY	
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO


-- PROCEDIMIENTO PARA FINALIZAR LAS FACTURAS EXPORTACION (faex_Finalizado = 1)
CREATE OR ALTER PROCEDURE Prod.UDP_tbFacturasExportacion_Finalizado
	@faex_Id  	INT
AS
BEGIN
	BEGIN TRY
		UPDATE [Prod].[tbFacturasExportacion]
		SET	   faex_Finalizado = 1
		WHERE  faex_Id  = @faex_Id  

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error:' + ERROR_MESSAGE()
	END CATCH
END
GO





/* PROCEDIMIENTOS tb.FacturasExportacionDetalles*/

-- PROCEDIMIENTO PARA LISTAR LAS FACTURAS EXPORTACION DETALLES
CREATE OR ALTER PROCEDURE Prod.UDP_tbFacturasExportacionDetalles_Listar
	@faex_Id INT
AS
BEGIN
	SELECT	Detail.fede_Id, 
			Detail.faex_Id, 
			Detail.code_Id,			

			PODetail.code_CantidadPrenda, 
			Style.esti_Descripcion,

			Talla.tall_Codigo,

			PODetail.code_Sexo, 

			Color.colr_Nombre,
			PODetail.code_Unidad, 
			PODetail.code_Valor, 
			PODetail.code_Impuesto, 
			PODetail.code_EspecificacionEmbalaje,
			Detail.fede_Cajas, 
			Detail.fede_Cantidad, 
			Detail.fede_PrecioUnitario, 
			Detail.fede_TotalDetalle,
			CONCAT('#: ', PODetail.code_CodigoDetalle, ' - ',Style.esti_Descripcion,' - ',Talla.tall_Codigo,' - ',PODetail.code_Sexo,' - ',Color.colr_Nombre) AS code_Descripcion 
	FROM Prod.tbFacturasExportacionDetalles AS Detail
	INNER JOIN Prod.tbOrdenCompraDetalles AS PODetail ON Detail.code_Id = PODetail.code_Id
	INNER JOIN Prod.tbEstilos AS Style ON PODetail.esti_Id = Style.esti_Id
	INNER JOIN Prod.tbTallas AS Talla ON PODetail.tall_Id = Talla.tall_Id
	INNER JOIN Prod.tbColores AS Color ON PODetail.colr_Id = Color.colr_Id
	WHERE Detail.faex_Id = @faex_Id
END
GO


-- PROCEDIMIENTO PARA INSERTAR LAS FACTURAS EXPORTACION DETALLES (ITEMS)
CREATE OR ALTER PROCEDURE Prod.UDP_tbFacturasExportacionDetalles_Insertar --141, 8, 34, 110, 35, 23232,3, '2023-08-29 15:07:45.000'
	@faex_Id				INT, 
	@code_Id				INT, 
	@fede_Cajas				INT, 
	@fede_Cantidad			DECIMAL(18,2), 
	@fede_PrecioUnitario	DECIMAL(18,2), 
	@fede_TotalDetalle		DECIMAL(18,2), 
	@usua_UsuarioCreacion	INT, 
	@fede_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
		
		INSERT INTO Prod.tbFacturasExportacionDetalles(faex_Id, code_Id, fede_Cajas, 
		fede_Cantidad, fede_PrecioUnitario, fede_TotalDetalle, usua_UsuarioCreacion, fede_FechaCreacion)
		VALUES(@faex_Id, @code_Id, @fede_Cajas, @fede_Cantidad, @fede_PrecioUnitario, @fede_TotalDetalle, @usua_UsuarioCreacion, @fede_FechaCreacion)
		

		DECLARE @faex_Total DECIMAL(18,2) = (SELECT SUM(fede_TotalDetalle) FROM Prod.tbFacturasExportacionDetalles WHERE faex_Id = @faex_Id)

		UPDATE Prod.tbFacturasExportacion 
		SET faex_Total = @faex_Total
		WHERE faex_Id = @faex_Id

		SELECT 1
	END TRY

	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO


-- PROCEDIMIENTO PARA LISTAR LAS FACTURAS EXPORTACION DETALLES (ITEMS)
CREATE OR ALTER PROCEDURE Prod.UDP_tbFacturasExportacionDetalles_Editar --37, 141, 8, 34, 110, 35, 2000, 3, '2023-08-29 15:07:45.000'
	@fede_Id						INT, 
	@faex_Id						INT, 
	@code_Id						INT, 
	@fede_Cajas						INT, 
	@fede_Cantidad					DECIMAL(18,2), 
	@fede_PrecioUnitario			DECIMAL(18,2), 
	@fede_TotalDetalle				DECIMAL(18,2),
	@usua_UsuarioModificacion		INT,	 
	@fede_FechaModificacion			DATETIME
AS
BEGIN
	BEGIN TRY

		UPDATE Prod.tbFacturasExportacionDetalles
		SET faex_Id = @faex_Id, 
			code_Id = @code_Id, 
			fede_Cajas = @fede_Cajas, 
			fede_Cantidad = @fede_Cantidad, 
			fede_PrecioUnitario = @fede_PrecioUnitario, 
			fede_TotalDetalle = @fede_TotalDetalle, 
			usua_UsuarioModificacion = @usua_UsuarioModificacion, 
			fede_FechaModificacion = @fede_FechaModificacion
		WHERE fede_Id = @fede_Id

		DECLARE @faex_Total DECIMAL(18,2) = (SELECT SUM(fede_TotalDetalle) FROM Prod.tbFacturasExportacionDetalles WHERE faex_Id = @faex_Id)

		UPDATE Prod.tbFacturasExportacion 
		SET faex_Total = @faex_Total
		WHERE faex_Id = @faex_Id

		SELECT 1
	END TRY

	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO


-- PROCEDIMIENTO PARA BORRAR LAS FACTURAS EXPORTACION DETALLES (ITEMS)
CREATE OR ALTER PROC Prod.UDP_tbFacturasExportacionDetalle_Eliminar --31
(@fede_Id  INT)
AS
BEGIN
	BEGIN TRY
		
		-- Primero Extraer el ID del encabezado de factura correspondiente (faex_Id)
		DECLARE @faex_Id INT = (SELECT faex_Id FROM Prod.tbFacturasExportacionDetalles WHERE fede_Id = @fede_Id)

		-- Borrar el registro por completo
		DELETE FROM [Prod].[tbFacturasExportacionDetalles]
		WHERE fede_Id = @fede_Id 

		-- Hacer la nueva sumatoria con los items que le quedan a esa factura
		DECLARE @faex_Total DECIMAL(18,2) = (SELECT SUM(fede_TotalDetalle) FROM Prod.tbFacturasExportacionDetalles WHERE faex_Id = @faex_Id)

		-- Actualizar el total del encabezado de factura
		UPDATE Prod.tbFacturasExportacion 
		SET faex_Total = @faex_Total
		WHERE faex_Id = @faex_Id

		SELECT 1
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
	END�CATCH
END
GO



-- PROCEDIMIENTO PARA LISTAR LAS DUCAS 
CREATE OR ALTER PROCEDURE Prod.UDP_DUCAsDDL
AS
BEGIN
	SELECT duca_No_Duca FROM Adua.tbDuca
	WHERE duca_Estado = 1
END
GO


-- PROCEDIMIENTO PARA LISTAR LAS ORDENES DE COMPRA QUE SI POSEEN ITEMS
CREATE OR ALTER PROCEDURE Prod.UDP_OrdenesCompraDDL
AS
BEGIN
	SELECT DISTINCT(PO.orco_Id), CONCAT('No. ', PO.orco_Id, ' - ', Clie.clie_Nombre_O_Razon_Social, ' - ', CONVERT(DATE, PO.orco_FechaEmision)) AS orco_Descripcion 
	FROM Prod.tbOrdenCompra AS PO
	INNER JOIN Prod.tbClientes AS Clie ON PO.orco_IdCliente = Clie.clie_Id
	INNER JOIN Prod.tbOrdenCompraDetalles AS POdetail ON PO.orco_Id = POdetail.orco_Id
	WHERE PO.orco_Estado = 1
END
GO


-- PROCEDIMIENTO PARA LISTAR LOS DETALLES (ITEMS) DE LA ORDEN DE COMPRA SELECCIONADA EN EL ENCABEZADO DE LA FACTURA EXPORTACION
CREATE OR ALTER PROCEDURE Prod.UDP_PODetallesByID 
	@faex_Id INT
AS
BEGIN 
	DECLARE @orco_Id INT = (SELECT orco_Id FROM Prod.tbFacturasExportacion WHERE faex_Id = @faex_Id)

	SELECT code.code_Id ,CONCAT('#: ', code.code_CodigoDetalle, ' - ',esti.esti_Descripcion,' - ',tall.tall_Codigo,' - ',code.code_Sexo,' - ',colr.colr_Nombre) AS code_Descripcion 
	FROM Prod.tbOrdenCompraDetalles code
	INNER JOIN Prod.tbEstilos AS esti ON code.esti_Id = esti.esti_Id
	INNER JOIN Prod.tbTallas AS tall ON code.tall_Id = tall.tall_Id
	INNER JOIN Prod.tbColores AS colr ON code.colr_Id = colr.colr_Id
	WHERE orco_Id = @orco_Id AND code.code_Estado = 1
END
GO


-- PROCEDIMIENTO PARA COMPROBAR SI EL NUMERO DE DUCA EXISTE
CREATE OR ALTER PROCEDURE Prod.UDP_ComprobarNoDUCA
	@duca_No_Duca NVARCHAR(100)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM Adua.tbDuca WHERE duca_No_Duca = @duca_No_Duca)
			BEGIN 
				SELECT duca_No_Duca FROM Adua.tbDuca WHERE duca_No_Duca = @duca_No_Duca
			END
		ELSE
			BEGIN
				SELECT 0
			END
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO


SELECT * FROM Prod.tbColores
SELECT * FROM Prod.tbTallas
SELECT * FROM Prod.tbOrdenCompraDetalles WHERE orco_Id = 1
SELECT * FROM Prod.tbOrdenCompra
SELECT * FROM Prod.tbFacturasExportacion 

SELECT * FROM Prod.tbFacturasExportacion WHERE faex_Id = 162
SELECT * FROM Prod.tbFacturasExportacionDetalles WHERE faex_Id = 162
GO
