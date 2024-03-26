param (
    [string]$carpetaOrigen,
    [string]$carpetaDestino
)

if (-not $carpetaOrigen -or -not $carpetaDestino) {
    Write-Host "Error: Debes proporcionar las rutas de las carpetas de origen y destino."
    exit
}
function Copiar-ArchivosRecursivamente {
    param (
        [string]$origen,
        [string]$destino
    )

       if (-not (Test-Path -Path $destino)) {
        New-Item -Path $destino -ItemType Directory -Force
    }

    $items = Get-ChildItem -Path $origen

    foreach ($item in $items) {
        $rutaDestinoItem = Join-Path -Path $destino -ChildPath $item.Name

        if ($item.PSIsContainer) {
            # Si es una carpeta, copiarla recursivamente
            Copiar-ArchivosRecursivamente -origen $item.FullName -destino $rutaDestinoItem
        } else {
            # Si es un archivo, copiarlo
            Copy-Item -Path $item.FullName -Destination $rutaDestinoItem -Force
            Write-Host "Archivo copiado: $($item.FullName) -> $rutaDestinoItem"
        }
    }
}

Copiar-ArchivosRecursivamente -origen $carpetaOrigen -destino $carpetaDestino


$archivosOrigen = Get-ChildItem -Path $carpetaOrigen -File -Recurse
$archivosDestino = Get-ChildItem -Path $carpetaDestino -File -Recurse

foreach ($archivoDestino in $archivosDestino) {
    $rutaRelativaDestino = $archivoDestino.FullName.Replace($carpetaDestino, "")
    $rutaOrigen = Join-Path -Path $carpetaOrigen -ChildPath $rutaRelativaDestino

    if (-not (Test-Path -Path $rutaOrigen)) {
        Remove-Item -Path $archivoDestino.FullName -Force
        Write-Host "Archivo eliminado: $($archivoDestino.FullName)"
    }
}


